import 'dart:io';

import 'package:asset/asset.dart';
import 'package:asset/src/asset_reference_builders/default_asset_reference_builder.dart';
import 'package:environment/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:style/style.dart';

class FileAssetReferenceBuilder extends AssetReferenceBuilder {
  @override
  Widget build(
    BuildContext context,
    AssetReferenceBuilderContext assetReferenceBuilderContext,
    double? width,
    double? height,
    BoxFit? fit,
  ) {
    final file = getAssetFile(assetReferenceBuilderContext.assetReference)!;
    final metadata = assetReferenceBuilderContext.assetMetadata;
    if (metadata.mimeType!.startsWith('image/')) {
      final fileImage = useMemoized(() => FileImage(file));
      useEffect(
        () {
          fileImage.evict();
          return null;
        },
        [file.lastModifiedSync()],
      );
      return StyledImage(
        key: ValueKey(file.lastModifiedSync()),
        image: fileImage,
        width: width,
        height: height,
        fit: fit,
      );
    } else if (metadata.mimeType!.startsWith('video/')) {
      return StyledVideo(
        videoPlayerController: useMemoized(
          () => VideoPlayerController.file(file),
          [file, file.lastModifiedSync()],
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
    if (input.context.context.environmentCoreComponent.platform == Platform.web) {
      return false;
    }

    return getAssetFile(input.assetReference) != null && input.assetMetadata.mimeType != null;
  }

  File? getAssetFile(AssetReference assetReference) {
    return AssetReferenceMetaModifier.getModifier(assetReference)?.getFile(assetReference);
  }
}
