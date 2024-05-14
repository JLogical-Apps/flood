import 'package:asset/src/asset_builders/image_asset_builder.dart';
import 'package:asset_core/asset_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model/model.dart';
import 'package:persistence/persistence.dart';
import 'package:utils/utils.dart';

abstract class AssetBuilder with IsModifier<AssetBuilderContext> {
  Widget build(AssetBuilderContext assetBuilderContext);

  static final assetBuilderResolver = ModifierResolver<AssetBuilder, AssetBuilderContext>(modifiers: [
    ImageAssetBuilder(),
  ]);

  static AssetBuilder? getAssetBuilder(AssetBuilderContext assetBuilderContext) {
    return assetBuilderResolver.resolveOrNull(assetBuilderContext);
  }

  static Widget buildAsset(AssetReference assetReference) {
    return HookBuilder(
      builder: (context) {
        final assetMetadataModel = useMemoized(() => assetReference.assetMetadataDataSource.getX().asModel());
        return ModelBuilder(
          model: assetMetadataModel,
          builder: (AssetMetadata assetMetadata) {
            final context = AssetBuilderContext(assetReference: assetReference, assetMetadata: assetMetadata);
            return HookBuilder(
              builder: (_) {
                return getAssetBuilder(context)?.build(context) ??
                    (throw Exception('Could not find an AssetBuilder for ${{
                      'assetReference': assetReference,
                      'assetMetadata': assetMetadataModel,
                    }}'));
              },
            );
          },
        );
      },
    );
  }
}

class AssetBuilderContext {
  final AssetReference assetReference;
  final AssetMetadata assetMetadata;

  AssetBuilderContext({required this.assetReference, required this.assetMetadata});
}
