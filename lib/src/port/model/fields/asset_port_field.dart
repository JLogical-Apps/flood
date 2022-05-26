import 'dart:async';

import '../../../pond/context/app_context.dart';
import '../../../pond/modules/asset/asset.dart';
import '../../../pond/modules/asset/asset_module.dart';
import '../port_field.dart';

class AssetPortField extends PortField<String?> {
  bool isChanged = false;
  Asset? newAsset;

  AssetPortField({required super.name, super.initialValue});

  @override
  Future submitMapper(String? value) async {
    if (!isChanged) {
      return value;
    }

    if (initialValue != null) {
      await locate<AssetModule>().deleteAsset(initialValue!);
    }

    value = null;

    if (newAsset != null) {
      final id = await locate<AssetModule>().uploadAsset(newAsset!);
      value = id;
    }

    return value;
  }
}
