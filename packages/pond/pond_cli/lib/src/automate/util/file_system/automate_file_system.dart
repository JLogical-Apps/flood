import 'dart:io';

import 'package:utils_core/utils_core.dart';

abstract class AutomateFileSystem {
  Directory get coreDirectory;

  Directory get appDirectory;

  Future<File> createTempFile(String name);

  factory AutomateFileSystem({
    required Directory Function(Directory coreDirectory) appDirectoryGetter,
  }) =>
      _AutomateFileSystemImpl.withDirectoryGetter(
        appDirectoryGetter: appDirectoryGetter,
      );
}

mixin IsAutomateFileSystem implements AutomateFileSystem {}

class _AutomateFileSystemImpl with IsAutomateFileSystem {
  @override
  final Directory coreDirectory;

  @override
  final Directory appDirectory;

  _AutomateFileSystemImpl._({required this.coreDirectory, required this.appDirectory});

  factory _AutomateFileSystemImpl.withDirectoryGetter({
    required Directory Function(Directory coreDirectory) appDirectoryGetter,
  }) {
    final file = File.fromUri(Platform.script);
    final coreDirectory = file.parent.getChain().firstWhere((directory) => (directory - 'pubspec.yaml').existsSync());

    return _AutomateFileSystemImpl._(
      coreDirectory: coreDirectory,
      appDirectory: appDirectoryGetter(coreDirectory),
    );
  }

  @override
  Future<File> createTempFile(String name) async {
    final file = coreDirectory / 'tool' / 'output' - name;
    await file.ensureCreated();

    return file;
  }
}

abstract class AutomateFileSystemWrapper implements AutomateFileSystem {
  AutomateFileSystem get fileSystem;
}

mixin IsAutomateFileSystemWrapper implements AutomateFileSystemWrapper {
  @override
  Directory get coreDirectory => fileSystem.coreDirectory;

  @override
  Directory get appDirectory => fileSystem.appDirectory;

  @override
  Future<File> createTempFile(String name) {
    return fileSystem.createTempFile(name);
  }
}
