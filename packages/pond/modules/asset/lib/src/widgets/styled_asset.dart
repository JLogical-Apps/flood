import 'package:asset/src/asset_builders/asset_builder.dart';
import 'package:asset_core/asset_core.dart';
import 'package:flutter/material.dart';

class StyledAsset extends StatelessWidget {
  final Asset asset;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const StyledAsset({super.key, required this.asset, this.width, this.height, this.fit});

  @override
  Widget build(BuildContext context) {
    return AssetBuilder.buildAsset(asset, width: width, height: height, fit: fit);
  }
}
