import 'dart:io';

import 'package:persistence_core/persistence_core.dart';

class FileSystem {
  final CrossDirectory storageDirectory;
  final CrossDirectory tempDirectory;

  const FileSystem({required this.storageDirectory, required this.tempDirectory});

  FileSystem.io({required Directory storageDirectory, required Directory tempDirectory})
      : storageDirectory = CrossDirectory.io(storageDirectory),
        tempDirectory = CrossDirectory.io(tempDirectory);
}
