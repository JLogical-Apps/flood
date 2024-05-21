import 'package:asset_core/asset_core.dart';
import 'package:equatable/equatable.dart';
import 'package:port_core/port_core.dart';
import 'package:utils_core/utils_core.dart';

class AssetPortField with IsPortFieldWrapper<AssetPortValue, AssetReferenceGetter?> {
  @override
  final PortField<AssetPortValue, AssetReferenceGetter?> portField;

  final AssetProvider assetProvider;

  AssetPortField({
    required AssetPortValue value,
    dynamic error,
    required this.assetProvider,
  }) : portField = PortField(
          value: value,
          error: error,
          submitRawMapper: (assetValue) {
            final id = assetValue.uploadedAsset?.id ?? assetValue.initialValue?.id;
            return id?.mapIfNonNull((id) => assetProvider.getterById(id));
          },
          submitMapper: (assetValue) async {
            if (assetValue.initialValue != null && (assetValue.uploadedAsset != null || assetValue.removed)) {
              await assetProvider.delete(assetValue.initialValue!.id);
            }
            if (assetValue.uploadedAsset != null) {
              final asset = await assetProvider.upload(assetValue.uploadedAsset!);
              return assetProvider.getterById(asset.id);
            } else if (assetValue.removed) {
              return null;
            } else {
              return assetValue.initialValue
                  ?.mapIfNonNull((assetReference) => assetProvider.getterById(assetReference.id));
            }
          },
        );

  @override
  AssetPortField copyWith({required AssetPortValue value, required error}) {
    return AssetPortField(
      value: value,
      assetProvider: assetProvider,
      error: error,
    )
      ..port = port
      ..fieldPath = fieldPath;
  }
}

class AssetPortValue with EquatableMixin {
  final AssetReference? initialValue;
  final Asset? uploadedAsset;
  final bool removed;

  AssetPortValue({
    required this.initialValue,
    required this.uploadedAsset,
    required this.removed,
  });

  AssetPortValue.initial({required this.initialValue})
      : uploadedAsset = null,
        removed = false;

  AssetPortValue withUpload(Asset upload) {
    return AssetPortValue(initialValue: initialValue, uploadedAsset: upload, removed: false);
  }

  AssetPortValue withRemoved() {
    return AssetPortValue(
      initialValue: initialValue,
      uploadedAsset: null,
      removed: true,
    );
  }

  AssetPortValue withRestored() {
    return AssetPortValue(
      initialValue: initialValue,
      uploadedAsset: null,
      removed: false,
    );
  }

  @override
  List<Object?> get props => [initialValue, uploadedAsset, removed];
}
