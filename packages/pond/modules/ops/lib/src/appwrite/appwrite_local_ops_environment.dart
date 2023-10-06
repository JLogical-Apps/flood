import 'dart:io';

import 'package:collection/collection.dart';
import 'package:drop_core/drop_core.dart';
import 'package:environment_core/environment_core.dart';
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

    await _installConfigFiles(context);

    await context.coreProject.run(
      'docker compose up -d --remove-orphans',
      workingDirectory: context.coreDirectory / 'appwrite',
    );
  }

  @override
  Future<void> onDeploy(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    await context.appwriteOutputDirectory.ensureCreated();

    final projectId = await _getProjectId(context, environmentType: environmentType);

    await context.appwriteTerminal.run('appwrite login', interactable: true);

    await _updatePlatforms(context, projectId: projectId);
    await _updateAppwriteJson(context, projectId: projectId);
  }

  @override
  Future<void> onDelete(AutomateCommandContext context, {required EnvironmentType environmentType}) async {
    if (!await _isDockerInstalled(context)) {
      throw Exception('Ensure docker is installed and running!');
    }

    await context.appwriteTerminal.run('docker compose stop');
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

    for (final (type, key) in desiredKeyByType.entryRecords) {
      if (existingPlatforms.none((platform) => type == platform.type && key == platform.key)) {
        await context.appwriteTerminal
            .run('appwrite projects createPlatform --projectId $projectId --type $type --name $key --key $key');
      }
    }
  }

  Future<void> _updateAppwriteJson(AutomateCommandContext context, {required String projectId}) async {
    final appwriteJson = {
      'projectId': projectId,
      'projectName': 'Flood',
      'functions': [],
      'databases': await _getDatabaseJsons(),
      'collections': await _getCollectionJsons(context),
    };

    final appwriteJsonFile = context.appwriteOutputDirectory - 'appwrite.json';
    await DataSource.static.file(appwriteJsonFile).mapJson().set(appwriteJson);

    await context.appwriteTerminal.run('appwrite deploy collection --all --yes');
  }

  Future<List<Map<String, dynamic>>> _getDatabaseJsons() async {
    return [
      {
        '\$id': _databaseId,
        'name': 'Default',
        '\$createdAt': DateTime.now().toIso8601String(),
        '\$updatedAt': DateTime.now().toIso8601String(),
        'enabled': true,
      },
    ];
  }

  Future<List<Map<String, dynamic>>> _getCollectionJsons(AutomateCommandContext context) async {
    final dropContext = context.automateContext.corePondContext.dropCoreComponent;
    final repositories = dropContext.repositories;

    return repositories
        .map((repository) => _getCollectionJson(context, repository: repository))
        .whereNonNull()
        .toList();
  }

  Map<String, dynamic>? _getCollectionJson(AutomateCommandContext context, {required Repository repository}) {
    final securityModifier = RepositorySecurityModifier.getModifierOrNull(repository);
    if (securityModifier == null) {
      return null;
    }

    final path = securityModifier.getPath(repository);
    if (path == null) {
      return null;
    }

    return {
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
    };
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
            'default': null,
          };
        })
        .whereNonNull()
        .toList();

    final typeJson = hasAbstractParent
        ? {
            'key': 't_type',
            'type': 'string',
            'status': 'available',
            'required': true,
            'array': false,
            'size': 256, // Types should not be larger than 256 characters.
            'default': null,
          }
        : null;

    return [
      if (typeJson != null) typeJson,
      ...behaviorJsons,
    ];
  }
}

extension on AutomateCommandContext {
  Directory get appwriteOutputDirectory => coreDirectory / 'appwrite' / 'output';

  Terminal get appwriteTerminal => terminal.withWorkingDirectory(appwriteOutputDirectory);
}
