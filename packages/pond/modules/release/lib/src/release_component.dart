import 'package:collection/collection.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:release/src/pipeline.dart';
import 'package:release/src/release_environment_type.dart';
import 'package:release/src/release_platform.dart';

class ReleaseAutomateComponent with IsAutomatePondComponent {
  final Map<ReleaseEnvironmentType, Pipeline> pipelines;

  ReleaseAutomateComponent({required this.pipelines});

  @override
  List<AutomateCommand> get commands => [
        ReleaseCommand(pipelines: pipelines),
      ];
}

class ReleaseCommand extends AutomateCommand<ReleaseCommand> {
  final Map<ReleaseEnvironmentType, Pipeline> pipelines;

  late final environmentProperty = field<String>(name: 'environment');

  ReleaseCommand({required this.pipelines});

  @override
  String get name => 'release';

  @override
  String get description => 'Publishes a release using a pipeline.';

  @override
  ReleaseCommand copy() {
    return ReleaseCommand(pipelines: pipelines);
  }

  @override
  Future<void> onRun(AutomateCommandContext context) async {
    final environment = getEnvironment();
    final pipeline = pipelines[environment] ??
        (throw Exception('Could not find pipeline for release environment [${environment.name}]'));

    for (final step in pipeline.pipelineSteps) {
      await step.execute(context, [ReleasePlatform.android, ReleasePlatform.ios, ReleasePlatform.web]);
    }
  }

  @override
  AutomatePathDefinition get pathDefinition => AutomatePathDefinition.property(environmentProperty);

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
}
