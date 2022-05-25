import 'dart:typed_data';

import '../asset_provider.dart';
import 'image_asset.dart';

abstract class ImageAssetProvider extends AssetProvider<ImageAsset, Uint8List> {}
