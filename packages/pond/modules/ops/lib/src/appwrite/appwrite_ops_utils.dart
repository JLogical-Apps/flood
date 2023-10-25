import 'dart:io';

import 'package:appwrite_core/appwrite_core.dart';
import 'package:collection/collection.dart';
import 'package:dart_appwrite/dart_appwrite.dart' hide Permission;
import 'package:dart_appwrite/models.dart' hide File;
import 'package:drop_core/drop_core.dart';
import 'package:environment_core/environment_core.dart';
import 'package:log_core/log_core.dart';
import 'package:ops/src/appwrite/appwrite_platform.dart';
import 'package:ops/src/appwrite/behavior/appwrite_attribute_behavior_modifier.dart';
import 'package:ops/src/appwrite/permission/permission_text_modifier.dart';
import 'package:ops/src/repository_security/repository_security_modifier.dart';
import 'package:path_core/path_core.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:task_core/task_core.dart';
import 'package:type/type.dart';
import 'package:utils_core/utils_core.dart';

const _databaseId = 'default';

class AppwriteOpsUtils {
  AppwriteOpsUtils._();

  static Future<bool> hasAppwriteCli(AutomateCommandContext context) async {
    try {
      await context.coreProject.run('appwrite -v');
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> installAppwriteCli(AutomateCommandContext context) async {
    await context.coreProject.run('npm install -g appwrite-cli');
    if (!await hasAppwriteCli(context)) {
      throw Exception('Could not install appwrite cli!');
    }
  }

  static Future<String> getProjectId(
    AutomateCommandContext context, {
    required EnvironmentType environmentType,
    required String locationDescription,
  }) async {
    return await context.getHiddenStateOrElse(
      'appwrite/${environmentType.name}/projectId',
      () => context.input(
          'Input your Appwrite Project ID. To do this, access $locationDescription, then sign in, then create a project, then go to the project settings, and paste in the Project ID.'),
    );
  }

  static Future<String> getApiKey(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    return await context.getHiddenStateOrElse(
      'appwrite/${environmentType.name}/apiKey',
      () => context.input(
          'Input your Appwrite Project API Key. To do this, go to your project page > Settings > View API Keys > Create API Key. Give it any name and no expiration date. Give it all scopes. Copy the API Key Secret and paste it here.'),
    );
  }

  static Future<List<AppwritePlatform>> getPlatforms(AutomateCommandContext context,
      {required String projectId}) async {
    final output = await context.appwriteTerminal.run('appwrite projects listPlatforms --projectId $projectId');

    return output
        .split('\n')
        .where((line) => line.contains('│'))
        .skip(1)
        .map((line) => line.withoutAnsiEscapeCodes)
        .map((line) {
      final values = line.split('│').map((e) => e.trim()).toList();
      return AppwritePlatform(
        id: values[0],
        name: values[3],
        type: values[4],
        key: values[5],
      );
    }).toList();
  }

  static Future<void> updatePlatforms(
    AutomateCommandContext context, {
    required String projectId,
    required String webDomain,
  }) async {
    final desiredKeyByType = {
      'flutter-android': await context.getAndroidIdentifier(),
      'flutter-ios': await context.getIosIdentifier(),
      'flutter-web': webDomain,
    };
    final existingPlatforms = await getPlatforms(context, projectId: projectId);

    final commands = desiredKeyByType
        .where((type, key) => existingPlatforms.none((platform) => type == platform.type && key == platform.key))
        .mapToIterable((type, key) => PlanItem.static.run(
              'appwrite projects createPlatform --projectId $projectId --type $type --name $key --key $key',
              workingDirectory: context.appwriteOutputDirectory,
            ))
        .toList();

    await context.confirmAndExecutePlan(Plan(commands));
  }

  static Future<void> updateAppwriteAttributes(AutomateCommandContext context, {required Client client}) async {
    final databases = Databases(client);

    await _createDatabaseIfNotExists(context, databases: databases);

    final existingCollections = (await databases.listCollections(databaseId: _databaseId)).collections;
    final newCollections = await _getCollections(context);

    final commands = <PlanItem>[];

    for (final collection in newCollections) {
      final existingCollection =
          existingCollections.firstWhereOrNull((existingCollection) => existingCollection.$id == collection.$id);
      commands.addAll(await _updateCollectionPlanItems(
        context,
        databases: databases,
        collection: collection,
        existingCollection: existingCollection,
      ));
    }

    final deletedCollections = existingCollections
        .where((collection) => newCollections.none((collection) => collection.$id == collection.$id));
    for (final deletedCollection in deletedCollections) {
      commands.addAll(await _deleteCollectionPlanItems(
        context,
        databases: databases,
        collection: deletedCollection,
      ));
    }

    await context.confirmAndExecutePlan(Plan(commands));
  }

  static Future<void> deployFunctions(
    AutomateCommandContext context, {
    required Client client,
    required File functionTemplate,
  }) async {
    final taskCoreComponent = context.automateContext.findOrNull<TaskCoreComponent>();
    if (taskCoreComponent == null) {
      return;
    }

    final functions = Functions(client);
    for (final (route, _) in taskCoreComponent.tasks.entryRecords) {
      final routePath = route.uri.toString();
      final functionId = routePath.replaceAll('/', '_').replaceFirst('_', '');

      final function = await guardAsync(() => functions.get(functionId: functionId));
      if (function == null) {
        await context.confirmAndExecutePlan(Plan.execute(
          'Create Function [$functionId]',
          (context) => functions.create(
            functionId: functionId,
            name: routePath,
            runtime: 'dart-3.0',
            enabled: true,
            logging: true,
            commands: 'dart pub get',
            entrypoint: 'lib/main.dart',
          ),
        ));
      }

      final archive = await DataSource.static
          .directory(context.coreDirectory / 'tool' / 'output' / 'functions' / 'functions')
          .mapTar(ignorePatterns: [
            RegExp('\\.packages/.*'),
            RegExp('\\.dart_tool/.*'),
            RegExp('appwrite/.*'),
            RegExp('firebase/.*'),
            RegExp('build/.*'),
          ])
          .mapGzip()
          .get();

      await DataSource.static.rawFile(context.appwriteOutputDirectory - 'functions.tar.gz').set(archive);

      await context.confirmAndExecutePlan(Plan.execute(
        'Create Deployment [$functionId]',
        (context) async {
          var deployment = await functions.createDeployment(
            functionId: functionId,
            code: InputFile.fromBytes(
              bytes: archive,
              filename: 'functions.tar.gz',
            ),
            activate: true,
          );

          deployment =
              await _deploymentStatusX(functions: functions, deployment: deployment, functionId: functionId).last;
          if (deployment.status == 'failed') {
            throw Exception('Deployment failed after ${deployment.buildTime}s of building.\n${deployment.buildLogs}');
          }

          await functions.updateDeployment(functionId: functionId, deploymentId: deployment.$id);
        },
      ));
    }
  }

  static Stream<Deployment> _deploymentStatusX({
    required Functions functions,
    required Deployment deployment,
    required String functionId,
  }) async* {
    while (true) {
      deployment = await functions.getDeployment(functionId: functionId, deploymentId: deployment.$id);
      yield deployment;

      if (deployment.status == 'ready' || deployment.status == 'failed') {
        break;
      }

      await Future.delayed(Duration(seconds: 1));
    }
  }

  static Future<void> _createDatabaseIfNotExists(AutomateCommandContext context, {required Databases databases}) async {
    final databaseExists = await guardAsync(() => databases.get(databaseId: _databaseId)) != null;
    if (databaseExists) {
      return;
    }

    await context.confirmAndExecutePlan(Plan.execute(
      'Create Default Database',
      (context) => databases.create(databaseId: _databaseId, name: 'Default'),
    ));
  }

  static Future<List<PlanItem>> _updateCollectionPlanItems(
    AutomateCommandContext context, {
    required Databases databases,
    required Collection collection,
    required Collection? existingCollection,
  }) async {
    final collectionPlanItems = <PlanItem>[];
    for (final attribute in collection.attributes) {
      final existingAttribute = await guardAsync(() => databases.getAttribute(
            databaseId: _databaseId,
            collectionId: collection.$id,
            key: attribute['key'],
          ));

      collectionPlanItems.addAll(await _updateAttributePlanItem(
        context,
        databases: databases,
        collection: collection,
        attribute: attribute,
        existingAttribute: existingAttribute,
      ));
    }

    final existingAttributes = existingCollection?.attributes ?? [];
    final unusedAttributes = existingAttributes
        .where((existingAttribute) =>
            collection.attributes.none((attribute) => attribute['key'] == existingAttribute['key']))
        .toList();
    for (final unusedAttribute in unusedAttributes) {
      final planItem = _deleteAttributePlanItem(
        context,
        databases: databases,
        collection: collection,
        attribute: unusedAttribute,
      );
      collectionPlanItems.add(planItem);
    }

    final existingIndexes = existingCollection?.indexes ?? [];
    final newIndexes = collection.indexes
        .where((index) => existingIndexes
            .none((existingIndex) => DeepCollectionEquality().equals(index.attributes, existingIndex.attributes)))
        .toList();
    for (final newIndex in newIndexes) {
      final planItem = _createIndexPlanItem(databases: databases, collection: collection, index: newIndex);
      collectionPlanItems.add(planItem);
    }

    final unusedIndexes = existingIndexes
        .where((existingIndex) => collection.indexes
            .none((index) => DeepCollectionEquality().equals(index.attributes, existingIndex.attributes)))
        .toList();
    for (final unusedIndex in unusedIndexes) {
      final planItem = await _deleteIndexPlanItem(
        context,
        databases: databases,
        collection: collection,
        index: unusedIndex,
      );
      collectionPlanItems.add(planItem);
    }

    final updateCollectionPlanItem = _updateCollectionPlanItem(
      context,
      databases: databases,
      collection: collection,
      existingCollection: existingCollection,
      collectionPlanItems: collectionPlanItems,
    );

    return [
      if (updateCollectionPlanItem != null) updateCollectionPlanItem,
      ...collectionPlanItems,
    ];
  }

  static PlanItem? _updateCollectionPlanItem(
    AutomateCommandContext context, {
    required Databases databases,
    required Collection collection,
    required Collection? existingCollection,
    required List<PlanItem> collectionPlanItems,
  }) {
    if (existingCollection == null) {
      return PlanItem.static.execute(
        'Create Collection [${collection.$id}]',
        (context) async {
          context.log('Creating Collection [${collection.$id}]');
          await databases.createCollection(
            databaseId: collection.databaseId,
            collectionId: collection.$id,
            name: collection.name,
            permissions: collection.$permissions.cast<String>(),
            enabled: collection.enabled,
            documentSecurity: collection.documentSecurity,
          );
        },
      );
    }

    if (!_areCollectionsEqual(collection, existingCollection) || collectionPlanItems.isNotEmpty) {
      return PlanItem.static.execute(
        'Update Collection [${collection.$id}]',
        (context) async {
          context.log('Updating Collection [${collection.$id}]');
          await databases.updateCollection(
            databaseId: collection.databaseId,
            collectionId: collection.$id,
            name: collection.name,
            permissions: collection.$permissions.cast<String>(),
            enabled: collection.enabled,
            documentSecurity: collection.documentSecurity,
          );
        },
      );
    }

    return null;
  }

  static Future<void> _createAttribute({
    required Databases databases,
    required Collection collection,
    required Map<String, dynamic> attribute,
  }) async {
    final attributeType = attribute['type'];
    switch (attributeType) {
      case 'boolean':
        await databases.createBooleanAttribute(
          databaseId: _databaseId,
          collectionId: collection.$id,
          key: attribute['key'],
          xrequired: attribute['required'],
          array: attribute['array'],
        );
      case 'datetime':
        await databases.createDatetimeAttribute(
          databaseId: _databaseId,
          collectionId: collection.$id,
          key: attribute['key'],
          xrequired: attribute['required'],
          array: attribute['array'],
        );
      case 'double':
        await databases.createFloatAttribute(
          databaseId: _databaseId,
          collectionId: collection.$id,
          key: attribute['key'],
          xrequired: attribute['required'],
          array: attribute['array'],
        );
      case 'integer':
        await databases.createIntegerAttribute(
          databaseId: _databaseId,
          collectionId: collection.$id,
          key: attribute['key'],
          xrequired: attribute['required'],
          array: attribute['array'],
        );
      case 'string':
        await databases.createStringAttribute(
          databaseId: _databaseId,
          collectionId: collection.$id,
          key: attribute['key'],
          size: attribute['size'],
          xrequired: attribute['required'],
          array: attribute['array'],
        );
    }
  }

  static Future<void> _updateAttribute({
    required Databases databases,
    required Collection collection,
    required Map<String, dynamic> attribute,
  }) async {
    final attributeType = attribute['type'];
    switch (attributeType) {
      case 'boolean':
        await databases.updateBooleanAttribute(
          databaseId: _databaseId,
          collectionId: collection.$id,
          key: attribute['key'],
          xrequired: attribute['required'],
          xdefault: null,
        );
      case 'datetime':
        await databases.updateDatetimeAttribute(
          databaseId: _databaseId,
          collectionId: collection.$id,
          key: attribute['key'],
          xrequired: attribute['required'],
          xdefault: null,
        );
      case 'double':
        await databases.updateFloatAttribute(
          databaseId: _databaseId,
          collectionId: collection.$id,
          key: attribute['key'],
          xrequired: attribute['required'],
          xdefault: null,
          min: attribute['min'] ?? -double.maxFinite,
          max: attribute['max'] ?? double.maxFinite,
        );
      case 'integer':
        await databases.updateIntegerAttribute(
          databaseId: _databaseId,
          collectionId: collection.$id,
          key: attribute['key'],
          xrequired: attribute['required'],
          xdefault: null,
          min: attribute['min'] ?? minInteger,
          max: attribute['max'] ?? maxInteger,
        );
      case 'string':
        await databases.updateStringAttribute(
          databaseId: _databaseId,
          collectionId: collection.$id,
          key: attribute['key'],
          xrequired: attribute['required'],
          xdefault: null,
        );
    }
  }

  static Future<List<PlanItem>> _updateAttributePlanItem(
    AutomateCommandContext context, {
    required Databases databases,
    required Collection collection,
    required Map<String, dynamic> attribute,
    required Map<String, dynamic>? existingAttribute,
  }) async {
    final isSizeDifferent = existingAttribute != null &&
        _areAttributesEqual(attribute, existingAttribute) &&
        attribute['size'] != existingAttribute['size'];
    if (isSizeDifferent) {
      return [
        _deleteAttributePlanItem(context, databases: databases, collection: collection, attribute: attribute),
        _createAttributePlanItem(databases: databases, collection: collection, attribute: attribute),
      ];
    }

    if (existingAttribute != null && _areAttributesEqual(attribute, existingAttribute)) {
      return [];
    }

    if (existingAttribute == null) {
      return [_createAttributePlanItem(databases: databases, collection: collection, attribute: attribute)];
    } else {
      return [
        PlanItem.static.execute(
          '  Update Attribute [${attribute['key']}]',
          (context) async {
            context.log('Updating Attribute [${attribute['key']}]');
            await _updateAttribute(databases: databases, collection: collection, attribute: attribute);
          },
        ),
      ];
    }
  }

  static PlanItem _createAttributePlanItem({
    required Databases databases,
    required Collection collection,
    required Map<String, dynamic> attribute,
  }) {
    return PlanItem.static.execute(
      '  Create Attribute [${attribute['key']}]',
      (context) async {
        context.log('Creating Attribute [${attribute['key']}]');
        await _createAttribute(databases: databases, collection: collection, attribute: attribute);
      },
    );
  }

  static PlanItem _createIndexPlanItem({
    required Databases databases,
    required Collection collection,
    required Index index,
  }) {
    return PlanItem.static.execute(
      '  Create Index [${index.key}]',
      (context) async {
        context.log('Creating Index [${index.key}]');
        await databases.createIndex(
          databaseId: _databaseId,
          collectionId: collection.$id,
          key: index.key,
          type: index.type,
          attributes: index.attributes.cast<String>(),
          orders: index.orders?.cast<String>(),
        );
      },
    );
  }

  static Future<PlanItem> _deleteIndexPlanItem(
    AutomateCommandContext context, {
    required Databases databases,
    required Collection collection,
    required Index index,
  }) async {
    return PlanItem.static.execute(
      '  Delete Index [${index.key}]',
      (context) async {
        context.log('Deleting Index [${index.key}]');
        await databases.deleteIndex(
          databaseId: _databaseId,
          collectionId: collection.$id,
          key: index.key,
        );
      },
    );
  }

  static bool _areAttributesEqual(Map<String, dynamic> a, Map<String, dynamic> b) {
    return a['type'] == b['type'] && a['key'] == b['key'] && a['required'] == b['required'];
  }

  static bool _areCollectionsEqual(Collection a, Collection b) {
    return a.$id == b.$id &&
        a.name == b.name &&
        DeepCollectionEquality().equals(a.$permissions, b.$permissions) &&
        a.enabled == b.enabled &&
        a.documentSecurity == b.documentSecurity;
  }

  static PlanItem _deleteAttributePlanItem(
    AutomateCommandContext context, {
    required Databases databases,
    required Collection collection,
    required dynamic attribute,
  }) {
    return PlanItem.static.execute(
      '  Delete Attribute [${attribute['key']}]',
      (context) async {
        context.log('Deleting Attribute [${attribute['key']}]');
        await databases.deleteAttribute(
          databaseId: _databaseId,
          collectionId: collection.$id,
          key: attribute['key'],
        );
      },
    );
  }

  static Future<List<PlanItem>> _deleteCollectionPlanItems(
    AutomateCommandContext context, {
    required Databases databases,
    required Collection collection,
  }) async {
    context.log('Deleting Collection [${collection.$id}]');
    return [
      PlanItem.static.execute(
        'Delete Collection [${collection.$id}]',
        (context) async {
          context.log('Deleting Collection [${collection.$id}]');
          await databases.deleteCollection(databaseId: _databaseId, collectionId: collection.$id);
        },
      )
    ];
  }

  static Future<List<Collection>> _getCollections(AutomateCommandContext context) async {
    final dropContext = context.automateContext.corePondContext.dropCoreComponent;
    final repositories = dropContext.repositories;

    return repositories.map((repository) => _getCollection(context, repository: repository)).whereNonNull().toList();
  }

  static Collection? _getCollection(AutomateCommandContext context, {required Repository repository}) {
    final dropContext = context.automateContext.corePondContext.dropCoreComponent;

    final securityModifier = RepositorySecurityModifier.getModifierOrNull(repository);
    if (securityModifier == null) {
      return null;
    }

    final path = securityModifier.getPath(repository);
    if (path == null) {
      return null;
    }

    final security = securityModifier.getSecurity(repository) ?? RepositorySecurity.none();

    List<String> getPermissionTexts({required String action, required Permission permission}) =>
        PermissionTextModifier.getModifier(permission)
            .getPermissions(dropContext, permission)
            .map((permissionText) => '$action("$permissionText")')
            .toList();

    return Collection.fromMap({
      '\$id': securityModifier.getPath(repository),
      '\$permissions': {
        'read': security.read,
        'create': security.create,
        'update': security.update,
        'delete': security.delete,
      }
          .mapToIterable((action, permission) => getPermissionTexts(action: action, permission: permission))
          .expand((list) => list)
          .toList(),
      'databaseId': _databaseId,
      'name': securityModifier.getPath(repository),
      'enabled': true,
      'documentSecurity': false,
      'attributes': _getAttributesJson(context, repository: repository),
      'indexes': _getIndexesJson(context, repository: repository),
    });
  }

  static List<Map<String, dynamic>> _getAttributesJson(
    AutomateCommandContext context, {
    required Repository repository,
  }) {
    return repository.handledTypes
        .expand((entityRuntimeType) => [entityRuntimeType, ...entityRuntimeType.getConcreteDescendants()]
            .where((runtimeType) => runtimeType.isConcrete)
            .map((runtimeType) => _getEntityAttributesJson(
                  context,
                  entity: runtimeType.createInstance(),
                  hasAbstractParent: entityRuntimeType.isAbstract,
                )))
        .expand((attributes) => attributes)
        .groupListsBy((attribute) => attribute['key'] as String)
        .mapToIterable((key, attribute) => attribute.first)
        .toList();
  }

  static List<Map<String, dynamic>> _getIndexesJson(AutomateCommandContext context, {required Repository repository}) {
    return repository.handledTypes
        .expand((entityRuntimeType) => [entityRuntimeType, ...entityRuntimeType.getConcreteDescendants()]
            .where((runtimeType) => runtimeType.isConcrete)
            .map((runtimeType) => _getEntityIndexesJson(context, entity: runtimeType.createInstance())))
        .expand((indexes) => indexes)
        .groupListsBy((index) => index['key'] as String)
        .mapToIterable((key, index) => index.first)
        .toList();
  }

  static List<Map<String, dynamic>> _getEntityAttributesJson(
    AutomateCommandContext context, {
    required Entity entity,
    required bool hasAbstractParent,
  }) {
    final dropContext = context.automateContext.corePondContext.dropCoreComponent;

    final valueObjectRuntimeType = dropContext.getRuntimeTypeRuntime(entity.valueObjectType);
    final valueObject = valueObjectRuntimeType.createInstance() as ValueObject;

    final behaviorJsons = valueObject.behaviors
        .whereType<ValueObjectProperty>()
        .map((property) {
          final behaviorModifier = AppwriteAttributeBehaviorModifier.getBehaviorModifierOrNull(property);
          if (behaviorModifier == null) {
            return null;
          }

          return {
            'key': property.name,
            'type': behaviorModifier.getType(property),
            'status': 'available',
            'required': hasAbstractParent ? false : behaviorModifier.isRequired(property),
            'array': behaviorModifier.isArray(property),
            if (behaviorModifier.getSize(property) != null) 'size': behaviorModifier.getSize(property),
            _databaseId: null,
          };
        })
        .whereNonNull()
        .toList();

    final typeJson = hasAbstractParent
        ? {
            'key': AppwriteConsts.typeKey,
            'type': 'string',
            'status': 'available',
            'required': true,
            'array': false,
            'size': 256, // Types should not be larger than 256 characters.
            _databaseId: null,
          }
        : null;

    return [
      if (typeJson != null) typeJson,
      ...behaviorJsons,
    ];
  }

  static List<Map<String, dynamic>> _getEntityIndexesJson(
    AutomateCommandContext context, {
    required Entity entity,
  }) {
    final dropContext = context.automateContext.corePondContext.dropCoreComponent;

    final valueObjectRuntimeType = dropContext.getRuntimeTypeRuntime(entity.valueObjectType);
    final valueObject = valueObjectRuntimeType.createInstance() as ValueObject;

    final indexJsons = valueObject.behaviors
        .whereType<ValueObjectProperty>()
        .map((property) {
          final behaviorModifier = AppwriteAttributeBehaviorModifier.getBehaviorModifierOrNull(property);
          if (behaviorModifier == null) {
            return null;
          }

          return [
            if (behaviorModifier.isIndexed(property))
              {
                'key': property.name,
                'type': 'key',
                'attributes': [property.name],
                'orders': [],
              },
            if (behaviorModifier.isArray(property))
              {
                'key': property.name,
                'type': 'fulltext',
                'attributes': [property.name],
                'orders': [],
              },
          ];
        })
        .whereNonNull()
        .expand((list) => list)
        .toList();

    return indexJsons;
  }
}

extension AppwriteAutomateCommandContext on AutomateCommandContext {
  Directory get appwriteDirectory => coreDirectory / 'appwrite';

  Directory get appwriteOutputDirectory => appwriteDirectory / 'output';

  Terminal get appwriteTerminal => terminal.withWorkingDirectory(appwriteOutputDirectory);

  Future<void> log(dynamic log) {
    return automateContext.corePondContext.log(log);
  }
}
