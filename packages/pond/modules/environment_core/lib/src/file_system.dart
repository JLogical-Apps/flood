import 'dart:io';

class FileSystem {
  final Directory storageDirectory;
  final Directory tempDirectory;

  const FileSystem({required this.storageDirectory, required this.tempDirectory});
}
