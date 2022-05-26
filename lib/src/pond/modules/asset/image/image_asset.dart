import 'dart:typed_data';

import '../asset.dart';

class ImageAsset extends Asset<Uint8List> {
  ImageAsset({required super.id, required super.value});
}
