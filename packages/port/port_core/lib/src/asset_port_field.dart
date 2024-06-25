import 'package:asset_core/asset_core.dart';
import 'package:equatable/equatable.dart';
import 'package:port_core/port_core.dart';
import 'package:utils_core/utils_core.dart';

class AssetPortField with IsPortFieldWrapper<AssetPortValue, AssetReferenceGetter?> {
  @override
  final PortField<AssetPortValue, AssetReferenceGetter?> portField;

  final AssetPathContext pathContext;

  final AssetProvider assetProvider;

  AssetPortField({
    required AssetPortValue value,
    required this.pathContext,
    dynamic error,
    required this.assetProvider,
  }) : portField = PortField(
          value: value,
          error: error,
          submitRawMapper: (assetValue) {
            final id = assetValue.uploadedAsset?.id ?? assetValue.initialValue?.id;
            return id?.mapIfNonNull((id) => assetProvider.getterById(pathContext, id));
          },
          submitMapper: (assetValue) async {
            if (assetValue.initialValue != null &&
                ((assetValue.uploadedAsset != null && assetValue.uploadedAsset?.id != assetValue.initialValue!.id) ||
                    assetValue.removed)) {
              await guardAsync(() => assetProvider.delete(pathContext, assetValue.initialValue!.id));
            }
            if (assetValue.uploadedAsset != null) {
              final asset = await assetProvider.upload(pathContext, assetValue.uploadedAsset!);
              return assetProvider.getterById(pathContext, asset.id);
            } else if (assetValue.removed) {
              return null;
            } else {
              return assetValue.initialValue
                  ?.mapIfNonNull((assetReference) => assetProvider.getterById(pathContext, assetReference.id));
            }
          },
        );

  @override
  AssetPortField copyWith({required AssetPortValue value, required error}) {
    return AssetPortField(
      pathContext: pathContext,
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

  AssetPortValue.initial({required this.initialValue, this.uploadedAsset}) : removed = false;

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
