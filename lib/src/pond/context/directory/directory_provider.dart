import 'dart:io';

abstract class DirectoryProvider {
  Directory get supportDirectory;
  Directory get cacheDirectory;
}