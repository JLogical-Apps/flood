import 'dart:async';
import 'dart:typed_data';

import '../../../pond/context/app_context.dart';
import '../../../pond/modules/asset/asset_module.dart';
import '../port_field.dart';

class AssetPortField extends PortField<String?> {
  final Type assetType;

  bool isChanged = false;
  Uint8List? preview;
  String? filename;

  AssetPortField({required super.name, super.initialValue, required this.assetType});

  @override
  Future submitMapper(String? value) async {
    if (!isChanged) {
      return value;
    }

    if (initialValue != null) {
      await locate<AssetModule>().deleteAssetRuntime(assetType: assetType, id: initialValue!);
    }

    value = null;

    if (preview != null) {
      final id = await locate<AssetModule>().uploadAssetRuntime(
        assetType: assetType,
        value: preview,
        suffix: filename,
      );
      value = id;
    }

    return value;
  }
}
