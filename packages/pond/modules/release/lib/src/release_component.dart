import 'dart:io';

import 'package:collection/collection.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:release/src/deploy_target.dart';
import 'package:release/src/metadata_context.dart';
import 'package:release/src/pipeline.dart';
import 'package:release/src/pipeline_step.dart';
import 'package:release/src/release_context.dart';
import 'package:release/src/release_environment_type.dart';
import 'package:release/src/release_platform.dart';

class ReleaseAutomateComponent with IsAutomatePondComponent {
  final Map<ReleaseEnvironmentType, Pipeline> pipelines;
  final List<ReleasePlatform>? platforms;
  final Map<ReleasePlatform, DeployTarget> appStoreDeployTargetByPlatform;
  final Directory Function(AutomateFileSystem fileSystem)? screenshotsDirectoryGetter;

  final List<PipelineStep> preBuildSteps;
  final List<PipelineStep> postBuildSteps;

  ReleaseAutomateComponent({
    required this.pipelines,
    this.platforms,
    required this.appStoreDeployTargetByPlatform,
    this.screenshotsDirectoryGetter,
    List<PipelineStep>? preBuildSteps,
    List<PipelineStep>? postBuildSteps,
  })  : preBuildSteps = preBuildSteps ?? [],
        postBuildSteps = postBuildSteps ?? [];

  @override
  List<AutomateCommand> get commands => [
        ReleaseCommand(
          pipelines: pipelines,
          platforms: platforms,
        ),
        AppStoreCommand(
          deployTargetByPlatform: appStoreDeployTargetByPlatform,
          platforms: platforms,
          screenshotsDirectoryGetter: screenshotsDirectoryGetter,
        ),
      ];

  void addPreBuildStep(PipelineStep step) {
    preBuildSteps.add(step);
  }

  void addPostBuildStep(PipelineStep step) {
    postBuildSteps.add(step);
  }
}

class ReleaseCommand extends AutomateCommand<ReleaseCommand> {
  final Map<ReleaseEnvironmentType, Pipeline> pipelines;
  final List<ReleasePlatform>? platforms;

  late final environmentProperty = field<String>(name: 'environment');
  late final platformsProperty = field<String>(name: 'only');
  late final buildOnlyProperty = field<bool>(name: 'buildOnly').withFallback(() => false);
  late final debugProperty = field<bool>(name: 'debug').withFallback(() => false);

  ReleaseCommand({required this.pipelines, required this.platforms});

  @override
  String get name => 'release';

  @override
  String get description => 'Publishes a release using a pipeline.';

  @override
  ReleaseCommand copy() {
    return ReleaseCommand(pipelines: pipelines, platforms: platforms);
  }

  @override
  Future<void> onRun(AutomateCommandContext context) async {
    final environment = getEnvironment();
    final pipeline = pipelines[environment] ??
        (throw Exception('Could not find pipeline for release environment [${environment.name}]'));
    final platforms = getPlatforms();

    final releaseContext = ReleaseContext(platforms: platforms, isDebug: debugProperty.value);

    if (buildOnlyProperty.value) {
      final buildStep = pipeline.pipelineSteps.firstWhere((step) => step.name == 'build');
      await buildStep.execute(context, releaseContext);
      return;
    }

    for (final step in pipeline.pipelineSteps) {
      if (context.path.parameters['skip_${step.name}'] == 'true') {
        print('SKIPPING [${step.name}]\n');
        continue;
      }

      print('===[${step.name}]===');
      await step.execute(context, releaseContext);
      print('');
    }
  }

  @override
  AutomatePathDefinition get pathDefinition => AutomatePathDefinition.property(environmentProperty);

  @override
  List<AutomateCommandProperty> get parameters => [platformsProperty, buildOnlyProperty, debugProperty];

  ReleaseEnvironmentType? getEnvironmentOrNull() {
    final releaseTypes = [
      ReleaseEnvironmentType.production,
      ReleaseEnvironmentType.beta,
      ReleaseEnvironmentType.alpha,
    ];

    return releaseTypes.firstWhereOrNull((releaseType) => releaseType.name == environmentProperty.value);
  }

  ReleaseEnvironmentType getEnvironment() {
    return getEnvironmentOrNull() ??
        (throw Exception('Cannot find release environment with name [${environmentProperty.value}]'));
  }

  List<ReleasePlatform> getPlatforms() {
    if (platformsProperty.value == null) {
      return getDefaultPlatforms();
    }

    return platformsProperty.value!
        .split(',')
        .map((rawPlatform) =>
            getDefaultPlatforms().firstWhere((platform) => platform.name.toLowerCase() == rawPlatform.toLowerCase()))
        .toList();
  }

  List<ReleasePlatform> getDefaultPlatforms() {
    return platforms ??
        [
          ReleasePlatform.android,
          ReleasePlatform.ios,
          ReleasePlatform.web,
        ];
  }
}

class AppStoreCommand extends AutomateCommand<AppStoreCommand> {
  final Map<ReleasePlatform, DeployTarget> deployTargetByPlatform;
  final List<ReleasePlatform>? platforms;
  final Directory Function(AutomateFileSystem fileSystem)? screenshotsDirectoryGetter;

  late final platformsProperty = field<String>(name: 'only');

  AppStoreCommand({required this.deployTargetByPlatform, this.platforms, this.screenshotsDirectoryGetter});

  @override
  String get name => 'app_store';

  @override
  String get description => 'Updates app stores screenshots.';

  @override
  AppStoreCommand copy() {
    return AppStoreCommand(
      deployTargetByPlatform: deployTargetByPlatform,
      screenshotsDirectoryGetter: screenshotsDirectoryGetter,
    );
  }

  @override
  Future<void> onRun(AutomateCommandContext context) async {
    final platforms = getPlatforms();

    final metadataContext = MetadataContext(
        screenshotsDirectory: screenshotsDirectoryGetter?.call(context.fileSystem) ??
            (throw Exception('Screenshots directory not provided!')));

    for (final platform in platforms) {
      final deployTarget = deployTargetByPlatform[platform];
      if (deployTarget == null) {
        continue;
      }

      await deployTarget.syncMetadata(context, metadataContext, platform);
    }
  }

  @override
  AutomatePathDefinition get pathDefinition => AutomatePathDefinition.empty;

  @override
  List<AutomateCommandProperty> get parameters => [platformsProperty];

  List<ReleasePlatform> getPlatforms() {
    if (platformsProperty.value == null) {
      return getDefaultPlatforms();
    }

    return platformsProperty.value!
        .split(',')
        .map((rawPlatform) =>
            getDefaultPlatforms().firstWhere((platform) => platform.name.toLowerCase() == rawPlatform.toLowerCase()))
        .toList();
  }

  List<ReleasePlatform> getDefaultPlatforms() {
    return platforms ??
        [
          ReleasePlatform.android,
          ReleasePlatform.ios,
          ReleasePlatform.web,
        ];
  }
}
