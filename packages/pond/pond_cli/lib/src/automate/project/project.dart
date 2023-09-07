import 'dart:io';

import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:pond_cli/src/automate/util/package_manager/package_manager.dart';
import 'package:pond_cli/src/automate/util/package_manager/pubspec_package_manager.dart';

abstract class Project with IsPackageManagerWrapper, IsTerminalWrapper {
  File get pubspecFile;

  factory Project({required File pubspecFile, required Terminal terminal, required String pubGetCommand}) {
    return _ProjectImpl(
      pubspecFile: pubspecFile,
      packageManager: PubspecPackageManager(
        terminal: terminal,
        pubspecFile: pubspecFile,
        pubGetCommand: pubGetCommand,
      ),
      terminal: terminal,
    );
  }
}

extension ProjectExtensions on Project {
  DataSource<Map<String, dynamic>> get pubspecYamlDataSource => DataSource.static.file(pubspecFile).mapYaml();

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
  final File pubspecFile;

  @override
  final PackageManager packageManager;

  @override
  final Terminal terminal;

  _ProjectImpl({required this.pubspecFile, required this.packageManager, required this.terminal});
}
