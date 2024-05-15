import 'package:asset/src/asset_reference_builders/default_asset_reference_builder.dart';
import 'package:asset_core/asset_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model/model.dart';
import 'package:utils/utils.dart';

abstract class AssetReferenceBuilder with IsModifier<AssetReferenceBuilderContext> {
  Widget build(AssetReferenceBuilderContext assetReferenceBuilderContext, double? width, double? height, BoxFit? fit);

  static final assetReferenceBuilderResolver =
      ModifierResolver<AssetReferenceBuilder, AssetReferenceBuilderContext>(modifiers: [
    DefaultAssetReferenceBuilder(),
  ]);

  static AssetReferenceBuilder? getAssetReferenceBuilder(AssetReferenceBuilderContext assetBuilderContext) {
    return assetReferenceBuilderResolver.resolveOrNull(assetBuilderContext);
  }

  static Widget buildAssetReference(AssetReference assetReference, {double? width, double? height, BoxFit? fit}) {
    return ModelBuilder(
      model: assetReference.assetMetadataModel,
      builder: (AssetMetadata assetMetadata) {
        final context = AssetReferenceBuilderContext(assetReference: assetReference, assetMetadata: assetMetadata);
        return HookBuilder(
          builder: (_) {
            return getAssetReferenceBuilder(context)?.build(context, width, height, fit) ??
                (throw Exception('Could not find an AssetReferenceBuilder for ${{
                  'assetReference': assetReference,
                  'assetMetadata': assetMetadata,
                }}'));
          },
        );
      },
    );
  }
}

class AssetReferenceBuilderContext {
  final AssetReference assetReference;
  final AssetMetadata assetMetadata;

  AssetReferenceBuilderContext({required this.assetReference, required this.assetMetadata});
}
