import 'dart:io';

import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';
import 'package:jlogical_utils/src/persistence/data_source/file_data_source.dart';
import 'package:jlogical_utils/src/pond/automation/package_registration.dart';
import 'package:jlogical_utils/src/utils/file_extensions.dart';
import 'package:process_run/shell.dart';

mixin WithPubspecPackageRegistration implements PackageRegistration {
  Map<String, dynamic>? _parsedPubspec;

  Future<bool> isPackageRegistered(String packageName, {bool? isDevDependency}) async {
    await _parsePubspecIfNeeded();

    var isRegistered = false;
    if (isDevDependency == null || isDevDependency == false) {
      isRegistered = _isDependencyRegistered(packageName);
    }
    if (isDevDependency == null || isDevDependency == true) {
      isRegistered = isRegistered || _isDevDependencyRegistered(packageName);
    }

    return isRegistered;
  }

  Future<void> registerPackage(String packageName, {required bool isDevDependency}) async {
    await Shell().run('''\
    dart pub add ${isDevDependency ? '--dev' : ''} $packageName
    flutter pub get
    ''');

    _parsedPubspec = null;
    if (!await isPackageRegistered(packageName, isDevDependency: isDevDependency)) {
      throw Exception('Unable to add package to pubspec.yaml');
    }
  }

  Future<void> _parsePubspecIfNeeded() async {
    if (_parsedPubspec != null) {
      return;
    }

    final pubspecDataSource = FileDataSource(file: Directory.current - 'pubspec.yaml').mapYaml();
    _parsedPubspec = (await pubspecDataSource.getData()) ?? (throw Exception('Cannot find pubspec.yaml to parse!'));
  }

  bool _isDependencyRegistered(String packageName) {
    return _parsedPubspec!['dependencies']?[packageName] != null;
  }

  bool _isDevDependencyRegistered(String packageName) {
    return _parsedPubspec!['dev_dependencies']?[packageName] != null;
  }
}
