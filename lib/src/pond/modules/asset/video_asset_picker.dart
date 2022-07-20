import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../../persistence/export_core.dart';
import 'asset.dart';

class VideoAssetPicker {
  static Future<Asset?> pickVideoFromGallery() async {
    return _pickVideo((picker) => picker.pickVideo(source: ImageSource.gallery));
  }

  static Future<Asset?> pickVideoFromCamera() {
    return _pickVideo((picker) => picker.pickVideo(source: ImageSource.camera));
  }

  static Future<Asset?> _pickVideo(Future<XFile?> fileGetter(ImagePicker imagePicker)) async {
    final picker = ImagePicker();
    final videoFile = await fileGetter(picker);
    if (videoFile == null) {
      return null;
    }

    final videoBytes = await videoFile.readAsBytes();
    return Asset.createNew(
      id: UuidIdGenerator().getId() + basename(videoFile.path),
      value: videoBytes,
    );
  }
}
