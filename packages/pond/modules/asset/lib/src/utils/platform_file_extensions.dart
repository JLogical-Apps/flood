import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:persistence/persistence.dart';

extension PlatformFileExtensions on PlatformFile {
  CrossFile asCrossFile() {
    final bytes = this.bytes ?? Uint8List(0);
    return CrossFile.static.fromBytes(path: name, bytesGetter: () => bytes);
  }
}
