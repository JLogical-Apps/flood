import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Creates a temp file and returns it.
/// [extension] will add an extension to the created file. For example, extension = '.png' will create 'temp1.png'
Future<File> createTempFile({String? extension}) async {
  var tempDir = await getTemporaryDirectory();

  var randomName = Uuid().v4();

  var file = File(join(tempDir.path, '$randomName${extension ?? ''}'));
  await file.create(recursive: true);

  return file;
}
