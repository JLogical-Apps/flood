import 'dart:io';

import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/src/automate/util/package_manager/package_manager.dart';
import 'package:pond_cli/src/automate/util/terminal/terminal.dart';

class PubspecPackageManager with IsPackageManager {
  final Terminal terminal;
  final File pubspecFile;
  final String pubGetCommand;

  PubspecPackageManager({
    required this.terminal,
    required this.pubspecFile,
    this.pubGetCommand = 'flutter pub get',
  });

  Map<String, dynamic>? _parsedPubspec;

  @override
  Future<bool> isPackageRegistered(String packageName, {bool? isDevDependency}) async {
    await _parsePubspecIfNeeded();

    var isRegistered = false;
    if (isDevDependency != true) {
      isRegistered |= _isDependencyRegistered(packageName);
    }
    if (isDevDependency != false) {
      isRegistered |= _isDevDependencyRegistered(packageName);
    }

    return isRegistered;
  }

  @override
  Future<void> registerPackage(String packageName, {required bool isDevDependency}) async {
    await terminal.run([
      'dart pub add ${isDevDependency ? '--dev' : ''} $packageName',
      pubGetCommand,
    ].join('\n'));

    _parsedPubspec = null;
    if (!await isPackageRegistered(packageName, isDevDependency: isDevDependency)) {
      throw Exception('Unable to add package to pubspec.yaml');
    }
  }

  Future<void> _parsePubspecIfNeeded() async {
    if (_parsedPubspec != null) {
      return;
    }

    final pubspecDataSource = DataSource.static.file(pubspecFile).mapYaml();
    _parsedPubspec = (await pubspecDataSource.getOrNull()) ?? (throw Exception('Cannot find pubspec.yaml to parse!'));
  }

  bool _isDependencyRegistered(String packageName) {
    return _parsedPubspec!['dependencies']?[packageName] != null;
  }

  bool _isDevDependencyRegistered(String packageName) {
    return _parsedPubspec!['dev_dependencies']?[packageName] != null;
  }
}
