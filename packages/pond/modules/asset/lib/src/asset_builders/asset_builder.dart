import 'package:asset/src/asset_builders/image_asset_builder.dart';
import 'package:asset/src/asset_builders/video_asset_builder.dart';
import 'package:asset_core/asset_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:utils/utils.dart';

abstract class AssetBuilder with IsModifier<Asset> {
  Widget build(BuildContext context, Asset asset, double? width, double? height, BoxFit? fit);

  static final assetBuilderResolver = ModifierResolver<AssetBuilder, Asset>(modifiers: [
    ImageAssetBuilder(),
    VideoAssetBuilder(),
  ]);

  static AssetBuilder? getAssetBuilder(Asset asset) {
    return assetBuilderResolver.resolveOrNull(asset);
  }

  static Widget buildAsset(Asset asset, {double? width, double? height, BoxFit? fit}) {
    return HookBuilder(
      builder: (context) {
        return getAssetBuilder(asset)?.build(context, asset, width, height, fit) ??
            (throw Exception('Could not find an AssetBuilder for [${asset.id}]'));
      },
    );
  }
}
