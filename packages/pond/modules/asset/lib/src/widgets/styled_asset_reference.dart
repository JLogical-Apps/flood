import 'package:asset/src/asset_reference_builders/asset_reference_builder.dart';
import 'package:asset_core/asset_core.dart';
import 'package:flutter/material.dart';

class StyledAssetReference extends StatelessWidget {
  final AssetReference assetReference;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const StyledAssetReference({super.key, required this.assetReference, this.width, this.height, this.fit});

  @override
  Widget build(BuildContext context) {
    return AssetReferenceBuilder.buildAssetReference(assetReference, width: width, height: height, fit: fit);
  }
}
