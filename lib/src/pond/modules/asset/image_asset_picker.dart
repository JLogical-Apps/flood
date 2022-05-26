import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'asset.dart';

class ImageAssetPicker {
  static Future<Asset?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile == null) {
      return null;
    }

    final imageBytes = await imageFile.readAsBytes();
    return Asset(name: basename(imageFile.path), value: imageBytes);
  }
}
