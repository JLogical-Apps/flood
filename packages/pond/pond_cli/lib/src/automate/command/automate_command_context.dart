import 'dart:io';

import 'package:pond_cli/src/automate/context/automate_pond_context.dart';
import 'package:pond_cli/src/automate/util/file_system/automate_file_system.dart';
import 'package:pond_cli/src/automate/util/package_manager/package_manager.dart';
import 'package:pond_cli/src/automate/util/package_manager/pubspec_package_manager.dart';
import 'package:pond_cli/src/automate/util/terminal/terminal.dart';
import 'package:utils_core/utils_core.dart';

class AutomateCommandContext with IsTerminalWrapper, IsPackageManagerWrapper, IsAutomateFileSystemWrapper {
  final AutomatePondContext automateContext;

  AutomateCommandContext._({required this.automateContext, required this.terminal});

  factory AutomateCommandContext({required AutomatePondContext automateContext, Terminal? terminal}) {
    final fileSystem = AutomateFileSystem();

    return AutomateCommandContext._(
      automateContext: automateContext,
      terminal: terminal ?? Terminal.static.shell(workingDirectory: fileSystem.getRootDirectory()),
    );
  }

  List<File> tempFiles = [];

  File get stateFile => getRootDirectory() / 'tool' - 'state.yaml';

  @override
  final Terminal terminal;

  @override
  late final PackageManager packageManager = PubspecPackageManager(terminal: this, fileSystem: this);

  @override
  late final AutomateFileSystem fileSystem = AutomateFileSystem();

  @override
  Future<File> createTempFile(String name) async {
    final file = await super.createTempFile(name);
    tempFiles.add(file);
    return file;
  }

  Future cleanup() async {
    for (final file in tempFiles) {
      file.deleteSync();
    }
  }

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
