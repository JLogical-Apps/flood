import 'dart:async';

import 'package:environment_core/src/environment_config.dart';
import 'package:environment_core/src/file_system.dart';

class FileSystemEnvironmentConfig with IsEnvironmentConfigWrapper {
  final FutureOr<FileSystem> Function() fileSystemGetter;

  @override
  final EnvironmentConfig environmentConfig;

  FileSystemEnvironmentConfig({required this.fileSystemGetter, required this.environmentConfig});

  @override
  Future<FileSystem> getFileSystem() async {
    return await fileSystemGetter();
  }
}
