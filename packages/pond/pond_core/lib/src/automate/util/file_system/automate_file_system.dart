import 'dart:io';

import 'package:utils_core/utils_core.dart';

abstract class AutomateFileSystem {
  Directory getRootDirectory();

  factory AutomateFileSystem() => _AutomateFileSystemImpl();
}

mixin IsAutomateFileSystem implements AutomateFileSystem {}

class _AutomateFileSystemImpl with IsAutomateFileSystem {
  @override
  Directory getRootDirectory() {
    final file = File.fromUri(Platform.script);
    final rootDirectory = file.parent.getChain().firstWhere((directory) => (directory - 'pubspec.yaml').existsSync());
    return rootDirectory;
  }
}

abstract class AutomateFileSystemWrapper implements AutomateFileSystem {
  AutomateFileSystem get fileSystem;
}

mixin IsAutomateFileSystemWrapper implements AutomateFileSystemWrapper {
  @override
  Directory getRootDirectory() {
    return fileSystem.getRootDirectory();
  }
}
