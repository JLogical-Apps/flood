import 'dart:async';

import '../../../pond/context/app_context.dart';
import '../../../pond/modules/asset/asset.dart';
import '../../../pond/modules/asset/asset_module.dart';
import '../port_field.dart';

class AssetPortField extends PortField<String?> {
  bool isChanged = false;
  Asset? newAsset;

  /// Whether to keep the id of the asset.
  final bool keepId;

  AssetPortField({required super.name, super.initialValue, this.keepId: false});

  @override
  Future submitMapper(String? value) async {
    if (!isChanged) {
      return value;
    }

    if (keepId) {
      return await _replaceAsset();
    } else {
      return await _deleteAndCreateAsset();
    }
  }

  Future<String?> _replaceAsset() async {
    String? value;

    if (newAsset != null) {
      final uploadAsset = newAsset!.withId(initialValue);
      final id = await locate<AssetModule>().uploadAsset(uploadAsset);
      value = id;
    }

    return value;
  }

  Future<String?> _deleteAndCreateAsset() async {
    if (initialValue != null) {
      await locate<AssetModule>().deleteAsset(initialValue!);
    }

    String? value;

    if (newAsset != null) {
      final id = await locate<AssetModule>().uploadAsset(newAsset!);
      value = id;
    }

    return value;
  }
}
