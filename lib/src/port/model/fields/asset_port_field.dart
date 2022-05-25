import 'dart:async';
import 'dart:typed_data';

import 'package:jlogical_utils/src/utils/export_core.dart';

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

    final oldAsset =
        initialValue.mapIfNonNull((value) => locate<AssetModule>().getAssetProviderRuntime(assetType).from(value));
    await oldAsset?.deleteIfUploaded();
    value = null;

    if (preview != null) {
      final asset = await locate<AssetModule>().getAssetProviderRuntime(assetType).create(preview);
      value = asset.id;
    }

    return value;
  }
}
