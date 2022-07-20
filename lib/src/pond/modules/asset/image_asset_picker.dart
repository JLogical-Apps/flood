import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../../persistence/export_core.dart';
import 'asset.dart';

class ImageAssetPicker {
  static Future<Asset?> pickImageFromGallery() async {
    return _pickImage((picker) => picker.pickImage(source: ImageSource.gallery));
  }

  static Future<Asset?> pickImageFromCamera() {
    return _pickImage((picker) => picker.pickImage(source: ImageSource.camera));
  }

  static Future<Asset?> _pickImage(Future<XFile?> fileGetter(ImagePicker imagePicker)) async {
    final picker = ImagePicker();
    final imageFile = await fileGetter(picker);
    if (imageFile == null) {
      return null;
    }

    final imageBytes = await imageFile.readAsBytes();
    return Asset.createNew(
      id: UuidIdGenerator().getId() + basename(imageFile.path),
      value: imageBytes,
    );
  }
}
