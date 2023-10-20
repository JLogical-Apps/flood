import 'package:pond_cli/pond_cli.dart';
import 'package:release/release.dart';

class FirebaseCrashlyticsAutomateComponent with IsAutomatePondComponent {
  @override
  Future onRegister(AutomatePondContext context) async {
    final releaseComponent = context.find<ReleaseAutomateComponent>();
    releaseComponent.addPostBuildStep(_FirebaseCrashlyticsUploadPipelineStep());
  }
}

class _FirebaseCrashlyticsUploadPipelineStep with IsPipelineStep {
  @override
  String get name => 'Upload Crashlytics';

  @override
  Future execute(AutomateCommandContext context, List<ReleasePlatform> platforms) async {

  }
}
