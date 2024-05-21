import 'package:asset/src/asset_reference_builders/asset_reference_builder.dart';
import 'package:asset/src/context_extensions.dart';
import 'package:asset_core/asset_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StyledAssetProperty extends HookWidget {
  final AssetReferenceGetter assetProperty;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const StyledAssetProperty({super.key, required this.assetProperty, this.width, this.height, this.fit});

  @override
  Widget build(BuildContext context) {
    final assetProvider = useMemoized(() => assetProperty.assetProviderGetter(context.assetCoreComponent));
    final assetReference = useMemoized(() => assetProvider.getById(assetProperty.id), [assetProperty.id]);
    return AssetReferenceBuilder.buildAssetReference(assetReference, width: width, height: height, fit: fit);
  }
}
