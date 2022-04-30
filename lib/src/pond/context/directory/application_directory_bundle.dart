import 'dart:io';

import 'package:jlogical_utils/src/pond/context/directory/directory_provider.dart';
import 'package:path_provider/path_provider.dart';

import 'directory_bundle.dart';

class ApplicationDirectoryBundle implements DirectoryProvider {
  @override
  Directory get supportDirectory => _supportDirectory!;

  final Directory? _supportDirectory;

  ApplicationDirectoryBundle({Directory? supportDirectory}) : _supportDirectory = supportDirectory;

  static Future<DirectoryBundle> generate() async {
    return DirectoryBundle(supportDirectory: await getApplicationSupportDirectory());
  }
}
