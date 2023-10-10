import 'dart:io';

import 'package:appwrite_core/appwrite_core.dart';
import 'package:collection/collection.dart';
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/models.dart';
import 'package:drop_core/drop_core.dart';
import 'package:environment_core/environment_core.dart';
import 'package:log_core/log_core.dart';
import 'package:ops/src/appwrite/appwrite_platform.dart';
import 'package:ops/src/appwrite/behavior/appwrite_attribute_behavior_modifier.dart';
import 'package:ops/src/ops_environment.dart';
import 'package:ops/src/repository_security/repository_security_modifier.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:type/type.dart';
import 'package:utils_core/utils_core.dart';

const _databaseId = 'default';

class AppwriteLocalOpsEnvironment with IsOpsEnvironment {
  @override
  Future<bool> exists(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    if (!await _isDockerInstalled(context)) {
      return false;
    }

    if (!await _hasAppwriteContainer(context)) {
      return false;
    }

    if (!await _hasAppwriteCli(context)) {
      return false;
    }

    return true;
  }

  @override
  Future<void> onCreate(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    if (!await _isDockerInstalled(context)) {
      throw Exception('Ensure docker is installed and running!');
    }

    if (!await _hasAppwriteCli(context)) {
      await _installAppwriteCli(context);
    }

    if (!await _hasConfigFiles(context)) {
      await _installConfigFiles(context);
    }

    await context.confirmAndExecutePlan(Plan([
      PlanItem.static.run(
        'docker compose up -d --remove-orphans',
        workingDirectory: context.appwriteDirectory,
      ),
    ]));
  }

  @override
  Future<void> onDeploy(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    await context.appwriteOutputDirectory.ensureCreated();

    final projectId = await _getProjectId(context, environmentType: environmentType);
    final apiKey = await _getApiKey(context, environmentType: environmentType);

    final client = Client(endPoint: 'https://localhost/v1', selfSigned: true).setProject(projectId).setKey(apiKey);

    await context.appwriteTerminal.run('appwrite login', interactable: true);

    await _updatePlatforms(context, projectId: projectId);
    await _updateAppwriteJson(context, client: client);
  }

  @override
  Future<void> onDelete(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    if (!await _isDockerInstalled(context)) {
      throw Exception('Ensure docker is installed and running!');
    }

    await context.confirmAndExecutePlan(Plan([
      PlanItem.static.run('docker compose stop', workingDirectory: context.appwriteDirectory),
    ]));
  }

  Future<bool> _hasConfigFiles(AutomateCommandContext context) async {
    return await DataSource.static.file(context.coreDirectory / 'appwrite' - 'docker-compose.yml').exists() &&
        await DataSource.static.file(context.coreDirectory / 'appwrite' - '.env').exists();
  }

  Future<void> _installConfigFiles(AutomateCommandContext context) async {
    final appwriteDockerComposeFile = context.coreDirectory / 'appwrite' - 'docker-compose.yml';
    final appwriteDockerComposeDataSource =
        DataSource.static.url(Uri.parse('https://appwrite.io/install/compose')).mapResponseBody();
    await DataSource.static.file(appwriteDockerComposeFile).set(await appwriteDockerComposeDataSource.get());

    final appwriteEnvFile = context.coreDirectory / 'appwrite' - '.env';
    final appwriteEnvDataSource = DataSource.static.url(Uri.parse('https://appwrite.io/install/env')).mapResponseBody();
    await DataSource.static.file(appwriteEnvFile).set(await appwriteEnvDataSource.get());
  }

  Future<bool> _isDockerInstalled(AutomateCommandContext context) async {
    try {
      await context.coreProject.run('docker version');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _hasAppwriteContainer(AutomateCommandContext context) async {
    final output = await context.coreProject.run('docker ps -f name=appwrite');
    return output.contains('appwrite');
  }

  Future<bool> _hasAppwriteCli(AutomateCommandContext context) async {
    try {
      await context.coreProject.run('appwrite -v');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _installAppwriteCli(AutomateCommandContext context) async {
    await context.coreProject.run('npm install -g appwrite-cli');
    if (!await _hasAppwriteCli(context)) {
      throw Exception('Could not install appwrite cli!');
    }
  }

  Future<String> _getProjectId(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    return await context.getHiddenStateOrElse(
      'appwrite/${environmentType.name}/projectId',
      () => context.input(
          'Input your Appwrite Project ID. To do this, access Appwrite at http://localhost/, then sign in, then create a project, then go to the project settings, and paste in the Project ID.'),
    );
  }

  Future<String> _getApiKey(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    return await context.getHiddenStateOrElse(
      'appwrite/${environmentType.name}/apiKey',
      () => context.input(
          'Input your Appwrite Project API Key. To do this, go to your project page > Settings > View API Keys > Create API Key. Give it any name and no expiration date. Give it all scopes. Copy the API Key Secret and paste it here.'),
    );
  }

  Future<List<AppwritePlatform>> _getPlatforms(AutomateCommandContext context, {required String projectId}) async {
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

  Future<void> _updatePlatforms(AutomateCommandContext context, {required String projectId}) async {
    final desiredKeyByType = {
      'flutter-android': await context.getAndroidIdentifier(),
      'flutter-ios': await context.getIosIdentifier(),
      'flutter-web': 'localhost',
    };
    final existingPlatforms = await _getPlatforms(context, projectId: projectId);

    final commands = desiredKeyByType
        .where((type, key) => existingPlatforms.none((platform) => type == platform.type && key == platform.key))
        .mapToIterable((type, key) => PlanItem.static.run(
              'appwrite projects createPlatform --projectId $projectId --type $type --name $key --key $key',
              workingDirectory: context.appwriteOutputDirectory,
            ))
        .toList();

    await context.confirmAndExecutePlan(Plan(commands));
  }

  Future<void> _updateAppwriteJson(AutomateCommandContext context, {required Client client}) async {
    final databases = Databases(client);

    final existingCollections = (await databases.listCollections(databaseId: _databaseId)).collections;
    final newCollections = await _getCollections(context);

    final commands = <PlanItem>[];

    for (final collection in newCollections) {
      commands.addAll(await _updateOrCreateCollectionPlanItems(
        context,
        databases: databases,
        collection: collection,
        existingCollections: existingCollections,
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

  Future<List<PlanItem>> _updateOrCreateCollectionPlanItems(
    AutomateCommandContext context, {
    required Databases databases,
    required Collection collection,
    required List<Collection> existingCollections,
  }) async {
    final existingCollection =
        existingCollections.firstWhereOrNull((existingCollection) => existingCollection.$id == collection.$id);
    if (existingCollection == null) {
      return await _createCollectionPlanItems(context, databases: databases, collection: collection);
    } else {
      return await _updateCollectionPlanItems(
        context,
        databases: databases,
        collection: collection,
        existingCollection: existingCollection,
      );
    }
  }

  Future<List<PlanItem>> _createCollectionPlanItems(
    AutomateCommandContext context, {
    required Databases databases,
    required Collection collection,
  }) async {
    final createCollectionPlanItem = PlanItem.static.execute(
      'Create Collection [${collection.$id}]',
      (context) async => await databases.createCollection(
        databaseId: collection.databaseId,
        collectionId: collection.$id,
        name: collection.name,
        permissions: collection.$permissions.cast<String>(),
        enabled: collection.enabled,
        documentSecurity: collection.documentSecurity,
      ),
    );

    final attributePlanItems = <PlanItem>[];
    for (final attribute in collection.attributes) {
      final planItem = await _updateOrCreateAttributePlanItem(context,
          databases: databases, collection: collection, attribute: attribute);
      if (planItem != null) {
        attributePlanItems.add(planItem);
      }
    }

    return [
      createCollectionPlanItem,
      ...attributePlanItems,
    ];
  }

  Future<PlanItem?> _updateOrCreateAttributePlanItem(
    AutomateCommandContext context, {
    required Databases databases,
    required Collection collection,
    required dynamic attribute,
  }) async {
    final existingAttribute = await guardAsync(() => databases.getAttribute(
          databaseId: _databaseId,
          collectionId: collection.$id,
          key: attribute['key'],
        ));

    if (existingAttribute == null) {
      return await _createAttributePlanItem(
        context,
        databases: databases,
        collection: collection,
        attribute: attribute,
      );
    } else {
      return await _updateAttributePlanItem(
        context,
        databases: databases,
        collection: collection,
        attribute: attribute,
        existingAttribute: existingAttribute,
      );
    }
  }

  Future<PlanItem> _createAttributePlanItem(
    AutomateCommandContext context, {
    required Databases databases,
    required Collection collection,
    required dynamic attribute,
  }) async {
    final createAttributeFunctionByType = {
      'boolean': (attribute) => databases.createBooleanAttribute(
            databaseId: _databaseId,
            collectionId: collection.$id,
            key: attribute['key'],
            xrequired: attribute['required'],
            array: attribute['array'],
          ),
      'datetime': (attribute) => databases.createDatetimeAttribute(
            databaseId: _databaseId,
            collectionId: collection.$id,
            key: attribute['key'],
            xrequired: attribute['required'],
            array: attribute['array'],
          ),
      'double': (attribute) => databases.createFloatAttribute(
            databaseId: _databaseId,
            collectionId: collection.$id,
            key: attribute['key'],
            xrequired: attribute['required'],
            array: attribute['array'],
          ),
      'integer': (attribute) => databases.createIntegerAttribute(
            databaseId: _databaseId,
            collectionId: collection.$id,
            key: attribute['key'],
            xrequired: attribute['required'],
            array: attribute['array'],
          ),
      'string': (attribute) => databases.createStringAttribute(
            databaseId: _databaseId,
            collectionId: collection.$id,
            key: attribute['key'],
            size: attribute['size'],
            xrequired: attribute['required'],
            array: attribute['array'],
          ),
    };

    return PlanItem.static.execute(
      '  Create attribute [${attribute['key']}]',
      (context) => createAttributeFunctionByType[attribute['type']]!(attribute),
    );
  }

  Future<PlanItem?> _updateAttributePlanItem(
    AutomateCommandContext context, {
    required Databases databases,
    required Collection collection,
    required dynamic attribute,
    required dynamic existingAttribute,
  }) async {
    if (_areAttributesEqual(attribute, existingAttribute)) {
      return null;
    }

    print(attribute);
    print(existingAttribute);

    final updateAttributeFunctionByType = {
      'boolean': (attribute) => databases.updateBooleanAttribute(
            databaseId: _databaseId,
            collectionId: collection.$id,
            key: attribute['key'],
            xrequired: attribute['required'],
            xdefault: null,
          ),
      'datetime': (attribute) => databases.updateDatetimeAttribute(
            databaseId: _databaseId,
            collectionId: collection.$id,
            key: attribute['key'],
            xrequired: attribute['required'],
            xdefault: null,
          ),
      'double': (attribute) => databases.updateFloatAttribute(
            databaseId: _databaseId,
            collectionId: collection.$id,
            key: attribute['key'],
            xrequired: attribute['required'],
            xdefault: null,
            min: attribute['min'] ?? -double.maxFinite,
            max: attribute['max'] ?? double.maxFinite,
          ),
      'integer': (attribute) => databases.updateIntegerAttribute(
            databaseId: _databaseId,
            collectionId: collection.$id,
            key: attribute['key'],
            xrequired: attribute['required'],
            xdefault: null,
            min: attribute['min'] ?? minInteger,
            max: attribute['max'] ?? maxInteger,
          ),
      'string': (attribute) => databases.updateStringAttribute(
            databaseId: _databaseId,
            collectionId: collection.$id,
            key: attribute['key'],
            xrequired: attribute['required'],
            xdefault: null,
          ),
    };

    return PlanItem.static.execute(
      '  Update Attribute [${attribute['key']}]',
      (context) => updateAttributeFunctionByType[attribute['type']]!(attribute),
    );
  }

  bool _areAttributesEqual(dynamic a, dynamic b) {
    return a['type'] == b['type'] && a['key'] == b['key'] && a['required'] == b['required'];
  }

  Future<List<PlanItem>> _updateCollectionPlanItems(
    AutomateCommandContext context, {
    required Databases databases,
    required Collection collection,
    required Collection existingCollection,
  }) async {
    final attributePlanItems = <PlanItem>[];
    for (final attribute in collection.attributes) {
      final planItem = await _updateOrCreateAttributePlanItem(context,
          databases: databases, collection: collection, attribute: attribute);
      if (planItem != null) {
        attributePlanItems.add(planItem);
      }
    }

    final unusedAttributes = existingCollection.attributes
        .where((existingAttribute) =>
            collection.attributes.none((attribute) => attribute['key'] == existingAttribute['key']))
        .toList();
    for (final unusedAttribute in unusedAttributes) {
      final planItem = await _deleteAttributePlanItem(context,
          databases: databases, collection: collection, attribute: unusedAttribute);
      if (planItem != null) {
        attributePlanItems.add(planItem);
      }
    }

    final updateCollectionPlanItem =
        !_areCollectionsEqual(collection, existingCollection) || attributePlanItems.isNotEmpty
            ? PlanItem.static.execute(
                'Update Collection [${collection.$id}]',
                (context) async => await databases.updateCollection(
                  databaseId: collection.databaseId,
                  collectionId: collection.$id,
                  name: collection.name,
                  permissions: collection.$permissions.cast<String>(),
                  enabled: collection.enabled,
                  documentSecurity: collection.documentSecurity,
                ),
              )
            : null;

    return [
      if (updateCollectionPlanItem != null) updateCollectionPlanItem,
      ...attributePlanItems,
    ];
  }

  bool _areCollectionsEqual(Collection a, Collection b) {
    return a.$id == b.$id &&
        a.name == b.name &&
        DeepCollectionEquality().equals(a.$permissions, b.$permissions) &&
        a.enabled == b.enabled &&
        a.documentSecurity == b.documentSecurity;
  }

  Future<PlanItem?> _deleteAttributePlanItem(
    AutomateCommandContext context, {
    required Databases databases,
    required Collection collection,
    required dynamic attribute,
  }) async {
    return PlanItem.static.execute(
      '  Delete Attribute [${attribute['key']}',
      (context) => databases.deleteAttribute(
        databaseId: _databaseId,
        collectionId: collection.$id,
        key: attribute['key'],
      ),
    );
  }

  Future<List<PlanItem>> _deleteCollectionPlanItems(
    AutomateCommandContext context, {
    required Databases databases,
    required Collection collection,
  }) async {
    context.log('Deleting Collection [${collection.$id}]');
    return [
      PlanItem.static.execute(
        'Delete Collection [${collection.$id}]',
        (context) => databases.deleteCollection(databaseId: _databaseId, collectionId: collection.$id),
      )
    ];
  }

  Future<List<Collection>> _getCollections(AutomateCommandContext context) async {
    final dropContext = context.automateContext.corePondContext.dropCoreComponent;
    final repositories = dropContext.repositories;

    return repositories.map((repository) => _getCollection(context, repository: repository)).whereNonNull().toList();
  }

  Collection? _getCollection(AutomateCommandContext context, {required Repository repository}) {
    final securityModifier = RepositorySecurityModifier.getModifierOrNull(repository);
    if (securityModifier == null) {
      return null;
    }

    final path = securityModifier.getPath(repository);
    if (path == null) {
      return null;
    }

    return Collection.fromMap({
      '\$id': securityModifier.getPath(repository),
      '\$permissions': [
        'create("any")',
        'read("any")',
        'update("any")',
        'delete("any")',
      ],
      'databaseId': _databaseId,
      'name': securityModifier.getPath(repository),
      'enabled': true,
      'documentSecurity': false,
      'attributes': _getAttributesJson(context, repository: repository),
      'indexes': [],
    });
  }

  List<Map<String, dynamic>> _getAttributesJson(AutomateCommandContext context, {required Repository repository}) {
    return repository.handledTypes
        .expand((entityRuntimeType) => [entityRuntimeType, ...entityRuntimeType.getConcreteDescendants()]
            .where((runtimeType) => runtimeType.isConcrete)
            .map((runtimeType) => _getEntityAttributesJson(context,
                entity: runtimeType.createInstance(), hasAbstractParent: entityRuntimeType.isAbstract)))
        .expand((attributes) => attributes)
        .groupListsBy((attribute) => attribute['key'] as String)
        .mapToIterable((key, attribute) => attribute.first)
        .toList();
  }

  List<Map<String, dynamic>> _getEntityAttributesJson(
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
            'required': behaviorModifier.isRequired(property),
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
}

extension on AutomateCommandContext {
  Directory get appwriteDirectory => coreDirectory / 'appwrite';

  Directory get appwriteOutputDirectory => appwriteDirectory / 'output';

  Terminal get appwriteTerminal => terminal.withWorkingDirectory(appwriteOutputDirectory);

  Future<void> log(dynamic log) {
    return automateContext.corePondContext.log(log);
  }
}
