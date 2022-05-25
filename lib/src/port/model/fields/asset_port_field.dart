import 'dart:async';
import 'dart:typed_data';

import '../../../pond/export.dart';
import '../port_field.dart';

class AssetPortField extends PortField<String?> {
  final Type assetType;

  bool isChanged = false;
  Uint8List? preview;

  AssetPortField({required super.name, super.initialValue, required this.assetType});

  @override
  Future submitMapper(String? value) async {
    if (!isChanged) {
      return;
    }

    if (initialValue != null) {
      await locate<AssetModule>().deleteAssetRuntime(assetType: assetType, id: initialValue!);
    }

    value = null;

    if (preview != null) {
      final id = await locate<AssetModule>().uploadAssetRuntime(assetType: assetType, value: preview);
      value = id;
    }

    return value;
  }
}
