import 'dart:io';

import 'package:jlogical_utils/src/pond/context/directory/directory_provider.dart';
import 'package:path_provider/path_provider.dart';

class DirectoryBundle implements DirectoryProvider {
  @override
  Directory get supportDirectory => _supportDirectory!;

  final Directory? _supportDirectory;

  DirectoryBundle({Directory? supportDirectory}) : _supportDirectory = supportDirectory;

  static DirectoryBundle empty() {
    return DirectoryBundle();
  }

  static Future<DirectoryBundle> generate() async {
    return DirectoryBundle(supportDirectory: await getApplicationSupportDirectory());
  }
}
