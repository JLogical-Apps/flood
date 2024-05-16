import 'dart:io';

import 'package:persistence_core/persistence_core.dart';

class FileSystem {
  final CrossDirectory storageDirectory;
  final CrossDirectory tempDirectory;
  final Directory? storageIoDirectory;
  final Directory? tempIoDirectory;

  const FileSystem({
    required this.storageDirectory,
    required this.tempDirectory,
    this.storageIoDirectory,
    this.tempIoDirectory,
  });

  FileSystem.io({required Directory storageDirectory, required Directory tempDirectory})
      : storageDirectory = CrossDirectory.static.io(storageDirectory),
        tempDirectory = CrossDirectory.static.io(tempDirectory),
        storageIoDirectory = storageDirectory,
        tempIoDirectory = tempDirectory;
}
