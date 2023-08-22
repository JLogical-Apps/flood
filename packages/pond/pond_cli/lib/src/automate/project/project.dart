import 'package:pond_cli/pond_cli.dart';
import 'package:pond_cli/src/automate/util/package_manager/package_manager.dart';

abstract class Project with IsPackageManagerWrapper, IsTerminalWrapper {
  factory Project({required PackageManager packageManager, required Terminal terminal}) {
    return _ProjectImpl(packageManager: packageManager, terminal: terminal);
  }
}

extension ProjectExtensions on Project {
  Future<void> ensurePackageInstalled(String packageName, {bool isDevDependency = false}) async {
    if (await isPackageRegistered(packageName, isDevDependency: isDevDependency)) {
      return;
    }

    final shouldAdd = confirm(
        '[$packageName] is needed to run this automation. Would you like to install it${isDevDependency ? ' as a dev dependency' : ''}?');
    if (!shouldAdd) {
      error('[$packageName] needs to be installed to run!');
      throw Exception('[$packageName] needs to be installed to run!');
    }

    await registerPackage(packageName, isDevDependency: isDevDependency);
  }
}

mixin IsProject implements Project {}

class _ProjectImpl with IsProject, IsTerminalWrapper, IsPackageManagerWrapper {
  @override
  final PackageManager packageManager;

  @override
  final Terminal terminal;

  _ProjectImpl({required this.packageManager, required this.terminal});
}
