import 'package:ops/src/build.dart';
import 'package:ops/src/environment_info.dart';
import 'package:pond_cli/pond_cli.dart';

abstract class OpsEnvironment {
  Future<bool> exists(AutomateCommandContext context);

  Future<void> onCreate(AutomateCommandContext context);

  Future<EnvironmentInfo> getInfo(AutomateCommandContext context);

  Future<void> onDeploy(AutomateCommandContext context, {required Build build});

  Future<void> onDelete(AutomateCommandContext context);
}

extension OpsEnvironmentExtensions on OpsEnvironment {
  Future<void> create(AutomateCommandContext context) {
    return onCreate(context);
  }

  Future<void> deploy(AutomateCommandContext context, {required Build build}) {
    return onDeploy(context, build: build);
  }

  Future<void> delete(AutomateCommandContext context) {
    return onDelete(context);
  }
}

mixin IsOpsEnvironment implements OpsEnvironment {}
