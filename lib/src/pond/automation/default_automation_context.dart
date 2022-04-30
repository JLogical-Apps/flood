import 'package:jlogical_utils/src/pond/automation/automation_context.dart';

import 'with_dcli_console_interactor.dart';
import 'with_default_console_interactor.dart';
import 'with_pubspec_package_registration.dart';

class DefaultAutomationContext = AutomationContext
    with WithDefaultConsoleInteractor, WithDcliConsoleInteractor, WithPubspecPackageRegistration;
