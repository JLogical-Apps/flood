import 'dart:io';

import 'package:jlogical_utils/src/pond/context/directory/directory_provider.dart';
import 'package:jlogical_utils/src/utils/file_extensions.dart';
import 'package:path_provider/path_provider.dart';

class DirectoryBundle implements DirectoryProvider {
  @override
  final Directory supportDirectory;

  const DirectoryBundle({required this.supportDirectory});

  static DirectoryBundle empty() {
    return DirectoryBundle(supportDirectory: Directory.current / '_junk');
  }

  static Future<DirectoryBundle> generate() async {
    return DirectoryBundle(supportDirectory: await getApplicationSupportDirectory());
  }
}
