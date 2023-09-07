import 'dart:io';

import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:pond_cli/src/automate/util/package_manager/package_manager.dart';
import 'package:pond_cli/src/automate/util/package_manager/pubspec_package_manager.dart';
import 'package:pond_cli/src/automate/util/terminal/shell_terminal.dart';
import 'package:utils_core/utils_core.dart';

class Project with IsPackageManagerWrapper, IsTerminalWrapper {
  final Directory directory;

  final String executableRoot; // Either 'dart' or 'flutter'.

  @override
  final PackageManager packageManager;

  @override
  final Terminal terminal;

  Project({required this.directory, required this.executableRoot, Terminal? terminal})
      : packageManager = PubspecPackageManager(
          terminal: terminal ?? ShellTerminal(workingDirectory: directory),
          pubspecFile: directory - 'pubspec.yaml',
        ),
        terminal = terminal ?? ShellTerminal(workingDirectory: directory);

  File get pubspecFile => directory - 'pubspec.yaml';

  DataSource<Map<String, dynamic>> get pubspecYamlDataSource => DataSource.static.file(pubspecFile).mapYaml();

  Directory get testDirectory => directory / 'test';

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
