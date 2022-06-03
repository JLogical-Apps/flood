import 'dart:async';

import '../../../pond/context/app_context.dart';
import '../../../pond/modules/asset/asset.dart';
import '../../../pond/modules/asset/asset_module.dart';
import '../port_field.dart';

class AssetPortField extends PortField<String?> {
  bool isChanged = false;
  Asset? newAsset;

  /// If non-null, the id to use to upload new assets with.
  final String? forcedAssetId;

  AssetPortField({required super.name, super.initialValue, this.forcedAssetId});

  @override
  Future submitMapper(String? value) async {
    if (!isChanged) {
      return value;
    }

    value = null;

    if (forcedAssetId != null) {
      newAsset = newAsset?.withId(forcedAssetId);
      value = forcedAssetId;
    }

    if (newAsset != null) {
      final id = await locate<AssetModule>().uploadAsset(newAsset!);
      value = id;
    }

    if (initialValue != null) {
      await locate<AssetModule>().deleteAsset(initialValue!);
    }

    return value;
  }
}
