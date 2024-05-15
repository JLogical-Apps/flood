import 'package:asset/asset.dart';
import 'package:image_picker/image_picker.dart';

extension XFileExtensions on XFile {
  Future<Asset> toAsset() async {
    return Asset.upload(path: path, value: await readAsBytes(), mimeType: mimeType);
  }
}
