import 'dart:io';

import 'package:asset_core/src/asset_reference.dart';
import 'package:asset_core/src/asset_references/meta/file_asset_reference_meta_modifier.dart';
import 'package:utils_core/utils_core.dart';

abstract class AssetReferenceMetaModifier<T extends AssetReference> with IsTypedModifier<T, AssetReference> {
  File? getFile(T assetReference) {
    return null;
  }

  static final assetReferenceMetaModifierResolver = ModifierResolver<AssetReferenceMetaModifier, AssetReference>(
    modifiers: [
      FileAssetReferenceMetaModifier(),
      WrapperAssetReferenceMetaModifier(),
    ],
  );

  static AssetReferenceMetaModifier? getModifier(AssetReference behavior) =>
      assetReferenceMetaModifierResolver.resolveOrNull(behavior);
}

class WrapperAssetReferenceMetaModifier<T extends AssetReferenceWrapper> extends AssetReferenceMetaModifier<T> {
  @override
  File? getFile(T assetReference) {
    final unwrappedAssetReference = assetReference.assetReference;
    return AssetReferenceMetaModifier.getModifier(unwrappedAssetReference)?.getFile(unwrappedAssetReference);
  }
}
