import 'dart:io';

import 'package:jlogical_utils/src/pond/context/directory/directory_provider.dart';

class DirectoryBundle implements DirectoryProvider {
  @override
  Directory get supportDirectory => _supportDirectory!;
  final Directory? _supportDirectory;

  @override
  Directory get cacheDirectory => _cacheDirectory!;
  final Directory? _cacheDirectory;

  DirectoryBundle({Directory? supportDirectory, Directory? cacheDirectory})
      : _supportDirectory = supportDirectory,
        _cacheDirectory = cacheDirectory;

  static DirectoryBundle empty() {
    return DirectoryBundle();
  }
}
