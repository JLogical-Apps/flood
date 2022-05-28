import 'dart:typed_data';

import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:rxdart/rxdart.dart';

import '../../../model/export_core.dart';
import '../../context/app_context.dart';
import '../../property/field_property.dart';
import 'asset.dart';
import 'asset_module.dart';

class AssetFieldProperty extends FieldProperty<String> {
  late BehaviorSubject<Model<Asset?>?> _modelX;

  late ValueStream<Uint8List?> valueX = _modelX.switchMapWithValue((model) =>
      model?.valueX.mapWithValue((value) => value.getOrNull()?.value) ??
      Stream<Uint8List?>.empty().publishValueSeeded(null));

  AssetFieldProperty({required super.name}) {
    _modelX = BehaviorSubject.seeded(getAssetModel());
    withListener((assetId) {
      if (assetId != null) {
        _modelX.value = getAssetModel();
      }
    });
  }

  /// Deletes the currently uploaded asset and sets the value of this property to the id of a newly uploaded asset with
  /// [assetValue].
  Future<void> uploadNewAssetAndSet(Asset? assetValue) async {
    if (value != null) {
      await locate<AssetModule>().deleteAsset(value!);
      value = null;
    }

    if (assetValue != null) {
      final id = await locate<AssetModule>().uploadAsset(assetValue);
      value = id;
    }
  }

  Model<Asset?>? getAssetModel() {
    return value.mapIfNonNull((value) => locate<AssetModule>().getAssetModel(value));
  }

  Future<Asset?> getAsset() async {
    return await getAssetModel()?.ensureLoadedAndGet();
  }
}
