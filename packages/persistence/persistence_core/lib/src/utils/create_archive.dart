import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as path;

extension ArchiveDirectoryExtensions on Directory {
  Archive createArchive({List<Pattern> ignorePatterns = const []}) {
    final archive = Archive();

    final dirName = path.basename(this.path);
    final files = listSync(recursive: true).where((element) =>
        ignorePatterns.none((ignoreWildcard) => path.relative(element.path, from: this.path).contains(ignoreWildcard)));

    for (var file in files) {
      // If it's a Directory, only add empty directories
      if (file is Directory) {
        var filename = path.relative(file.path, from: this.path);
        filename = '$dirName/$filename';
        final af = ArchiveFile('$filename/', 0, null);
        af.mode = file.statSync().mode;
        af.isFile = false;
        archive.addFile(af);
      } else if (file is File) {
        // It's a File
        var filename = path.relative(file.path, from: this.path);
        filename = '$dirName/$filename';

        final fileStream = InputFileStream(file.path);
        final af = ArchiveFile.stream(filename, file.lengthSync(), fileStream);
        af.lastModTime = file.lastModifiedSync().millisecondsSinceEpoch ~/ 1000;
        af.mode = file.statSync().mode;

        archive.addFile(af);
      }
    }

    return archive;
  }
}
