import 'package:args/args.dart';
import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/pond/automation/automation_interactor.dart';
import 'package:jlogical_utils/src/pond/automation/automation_registration.dart';
import 'package:jlogical_utils/src/pond/automation/package_registration.dart';
import 'package:jlogical_utils/src/pond/automation/with_automation_registration.dart';
import 'package:jlogical_utils/src/pond/automation/with_console_automation_output.dart';
import 'package:jlogical_utils/src/pond/automation/with_pubspec_package_registration.dart';
import 'package:jlogical_utils/src/pond/automation/with_shell_automation_interactor.dart';
import 'package:jlogical_utils/src/pond/context/environment/environment.dart';

class AutomationContext
    with
        WithConsoleAutomationOutput,
        WithShellAutomationInteractor,
        WithAutomationRegistration,
        WithPubspecPackageRegistration
    implements AutomationInteractor, AutomationRegistration, PackageRegistration {
  late ArgResults args;

  Environment get environment {
    final envOption = args['environment'] ?? Environment.testing.name;
    return Environment.values.firstWhereOrNull((env) => env.name == envOption) ??
        (throw Exception('Environment not recognized!'));
  }

  bool get isClean => args['clean'];

  Future<bool> ensurePackageRegistered(String packageName, {required bool isDevDependency}) async {
    if (await isPackageRegistered(packageName, isDevDependency: isDevDependency)) {
      return true;
    }

    final shouldAddPackage = confirm(
        '`$packageName` needs to be installed. Would you like to add `$packageName` as a ${isDevDependency ? 'dev_dependency' : 'dependency'}?');

    if (!shouldAddPackage) {
      return false;
    }

    await registerPackage(packageName, isDevDependency: isDevDependency);

    return true;
  }
}
