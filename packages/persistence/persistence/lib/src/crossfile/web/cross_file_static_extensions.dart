import 'package:persistence/src/crossfile/web/web_cross_directory.dart';
import 'package:persistence/src/crossfile/web/web_cross_file.dart';
import 'package:persistence_core/persistence_core.dart';

extension WebCrossFileStaticExtensions on CrossFileStatic {
  CrossFile web(String path) => WebCrossFile(path: path);
}

extension WebCrossDirectoryExtensions on CrossDirectoryStatic {
  CrossDirectory web(String path) => WebCrossDirectory(path: path);
}
