import 'package:asset_core/asset_core.dart';
import 'package:file_picker/file_picker.dart';

extension FileTypeAllowedFileTypesExtensions on AllowedFileTypes {
  FileType asFileType() {
    if (this is ImageAllowedFileTypes) {
      return FileType.image;
    } else if (this is VideoAllowedFileTypes) {
      return FileType.video;
    } else if (this is AudioAllowedFileTypes) {
      return FileType.audio;
    } else if (this is CustomAllowedFileTypes) {
      return FileType.custom;
    } else {
      return FileType.any;
    }
  }

  List<String>? getAllowedExtensions() {
    if (this is CustomAllowedFileTypes) {
      return (this as CustomAllowedFileTypes).allowedFileTypes;
    } else {
      return null;
    }
  }
}
