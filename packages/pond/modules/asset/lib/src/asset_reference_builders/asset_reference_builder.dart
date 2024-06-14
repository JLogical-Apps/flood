import 'package:asset/asset.dart';
import 'package:asset/src/asset_reference_builders/default_asset_reference_builder.dart';
import 'package:asset/src/asset_reference_builders/file_asset_reference_builder.dart';
import 'package:asset/src/asset_reference_builders/uri_asset_reference_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model/model.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

abstract class AssetReferenceBuilder with IsModifier<AssetReferenceBuilderContext> {
  Widget build(BuildContext context, AssetReferenceBuilderContext assetReferenceBuilderContext, double? width,
      double? height, BoxFit? fit);

  static final assetReferenceBuilderResolver =
      ModifierResolver<AssetReferenceBuilder, AssetReferenceBuilderContext>(modifiers: [
    FileAssetReferenceBuilder(),
    UriAssetReferenceBuilder(),
    DefaultAssetReferenceBuilder(),
  ]);

  static AssetReferenceBuilder? getAssetReferenceBuilder(AssetReferenceBuilderContext assetBuilderContext) {
    return assetReferenceBuilderResolver.resolveOrNull(assetBuilderContext);
  }

  static Widget buildAssetReference(AssetReference assetReference, {double? width, double? height, BoxFit? fit}) {
    return Builder(builder: (context) {
      return ModelBuilder(
        model: assetReference.assetMetadataModel,
        builder: (AssetMetadata assetMetadata) {
          final assetReferenceContext = AssetReferenceBuilderContext(
            context: context.assetCoreComponent,
            assetReference: assetReference,
            assetMetadata: assetMetadata,
          );
          return HookBuilder(
            builder: (context) {
              return getAssetReferenceBuilder(assetReferenceContext)
                      ?.build(context, assetReferenceContext, width, height, fit) ??
                  (throw Exception('Could not find an AssetReferenceBuilder for ${{
                    'assetReference': assetReference,
                    'assetMetadata': assetMetadata,
                  }}'));
            },
          );
        },
        errorBuilder: (error, stackTrace) {
          return StyledContainer(
            width: width,
            height: height,
            child: AspectRatio(
              aspectRatio: 1,
              child: Center(
                child: StyledIcon(Icons.error, color: Colors.red),
              ),
            ),
          );
        },
      );
    });
  }
}

class AssetReferenceBuilderContext {
  final AssetCoreComponent context;
  final AssetReference assetReference;
  final AssetMetadata assetMetadata;

  AssetReferenceBuilderContext({
    required this.context,
    required this.assetReference,
    required this.assetMetadata,
  });
}
