import 'package:asset/asset.dart';
import 'package:asset/src/asset_reference_builders/default_asset_reference_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:style/style.dart';

class UriAssetReferenceBuilder extends AssetReferenceBuilder {
  @override
  Widget build(
    BuildContext context,
    AssetReferenceBuilderContext assetReferenceBuilderContext,
    double? width,
    double? height,
    BoxFit? fit,
  ) {
    final metadata = assetReferenceBuilderContext.assetMetadata;
    if (metadata.isImage) {
      final networkImage = useMemoized(() => NetworkImage(metadata.uri!.toString()), [metadata.uri]);
      return StyledImage(
        key: ValueKey(metadata.uri),
        image: networkImage,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) =>
            DefaultAssetReferenceBuilder().build(context, assetReferenceBuilderContext, width, height, fit),
      );
    } else if (metadata.mimeType!.startsWith('video/')) {
      return StyledVideo(
        videoPlayerController: useMemoized(
          () => VideoPlayerController.networkUrl(metadata.uri!),
          [metadata.uri!],
        ),
        width: width,
        height: height,
        fit: fit,
      );
    }

    return DefaultAssetReferenceBuilder().build(context, assetReferenceBuilderContext, width, height, fit);
  }

  @override
  bool shouldModify(AssetReferenceBuilderContext input) {
    return input.assetMetadata.uri != null;
  }
}
