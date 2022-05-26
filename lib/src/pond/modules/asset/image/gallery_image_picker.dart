import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:jlogical_utils/src/pond/modules/asset/asset_picker.dart';
import 'package:path/path.dart';

import 'image_asset.dart';

class GalleryImagePicker extends AssetPicker<ImageAsset, Uint8List> {
  @override
  Future<ImageAsset?> pickAsset() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile == null) {
      return null;
    }

    final imageBytes = await imageFile.readAsBytes();
    return ImageAsset(id: basename(imageFile.path), value: imageBytes);
  }
}
