import 'package:asset/src/asset_builders/asset_builder.dart';
import 'package:asset_core/asset_core.dart';
import 'package:flutter/material.dart';
import 'package:style/style.dart';

class ImageAssetBuilder extends AssetBuilder {
  @override
  Widget build(Asset asset, double? width, double? height, BoxFit? fit) {
    return StyledImage(
      image: MemoryImage(asset.value),
      width: width,
      height: height,
      fit: fit,
    );
  }

  @override
  bool shouldModify(Asset input) {
    return input.metadata.mimeType?.startsWith('image/') ?? false;
  }
}
