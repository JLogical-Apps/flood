import 'package:collection/collection.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:release/src/pipeline.dart';
import 'package:release/src/release_environment_type.dart';
import 'package:release/src/release_platform.dart';

class ReleaseAutomateComponent with IsAutomatePondComponent {
  final Map<ReleaseEnvironmentType, Pipeline> pipelines;
  final List<ReleasePlatform>? platforms;

  ReleaseAutomateComponent({required this.pipelines, this.platforms});

  @override
  List<AutomateCommand> get commands => [
        ReleaseCommand(pipelines: pipelines, platforms: platforms),
      ];
}

class ReleaseCommand extends AutomateCommand<ReleaseCommand> {
  final Map<ReleaseEnvironmentType, Pipeline> pipelines;
  final List<ReleasePlatform>? platforms;

  late final environmentProperty = field<String>(name: 'environment');
  late final platformsProperty = field<String>(name: 'only');

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

    for (final step in pipeline.pipelineSteps) {
      if (context.path.parameters['skip_${step.name}'] == 'true') {
        print('SKIPPING [${step.name}]\n');
        continue;
      }

      print('===[${step.name}]===');
      await step.execute(context, platforms);
      print('');
    }
  }

  @override
  AutomatePathDefinition get pathDefinition => AutomatePathDefinition.property(environmentProperty);

  @override
  List<AutomateCommandProperty> get parameters => [platformsProperty];

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
