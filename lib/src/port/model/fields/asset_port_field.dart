import 'dart:async';

import 'package:jlogical_utils/jlogical_utils_core.dart';

import '../../../pond/context/app_context.dart';
import '../../../pond/modules/asset/asset.dart';
import '../../../pond/modules/asset/asset_module.dart';
import '../../../pond/modules/asset/asset_provider.dart';

class AssetPortField extends PortField<String?> {
  bool isChanged = false;
  Asset? newAsset;

  /// If non-null, the id to use to upload new assets with.
  final String? forcedAssetId;

  final AssetProvider? assetProvider;

  AssetPortField({
    required super.name,
    String? initialValue,
    this.forcedAssetId,
    super.initialFallback,
    this.assetProvider,
  }) : super(initialValue: initialValue ?? forcedAssetId) {
    withSimpleValidator(Validator.of((_) async {
      if (!isChanged || newAsset == null) {
        return;
      }

      final exception = await locate<AssetModule>().getAssetUploadException(newAsset!);
      if (exception != null) {
        throw exception;
      }
    }));
  }

  @override
  Future submitMapper(String? value) async {
    if (!isChanged) {
      return value;
    }

    value = null;

    if (forcedAssetId != null) {
      newAsset = newAsset?.copyWith(id: forcedAssetId);
      value = forcedAssetId;
    }

    if (newAsset != null) {
      final uploadedAsset = await locate<AssetModule>().uploadAsset(newAsset!, assetProvider: assetProvider);
      value = uploadedAsset.id!;
    }

    if (initialValue != null && forcedAssetId == null) {
      await locate<AssetModule>().deleteAsset(initialValue!, assetProvider: assetProvider);
    }

    return value;
  }
}
