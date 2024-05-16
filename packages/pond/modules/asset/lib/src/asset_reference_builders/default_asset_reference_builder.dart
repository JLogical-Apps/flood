import 'package:asset/asset.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';

class DefaultAssetReferenceBuilder extends AssetReferenceBuilder {
  @override
  Widget build(BuildContext context, AssetReferenceBuilderContext assetReferenceBuilderContext, double? width,
      double? height, BoxFit? fit) {
    return ModelBuilder(
      model: assetReferenceBuilderContext.assetReference.assetModel,
      builder: (Asset asset) {
        return AssetBuilder.buildAsset(asset, width: width, height: height, fit: fit);
      },
    );
  }

  @override
  bool shouldModify(AssetReferenceBuilderContext input) {
    return true;
  }
}
