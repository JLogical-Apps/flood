import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:rxdart/rxdart.dart';

import '../../../model/export_core.dart';
import '../../context/app_context.dart';
import '../../property/field_property.dart';
import 'asset.dart';
import 'asset_module.dart';

class AssetFieldProperty<A extends Asset<T>, T> extends FieldProperty<String> {
  late BehaviorSubject<Model<T?>?> _modelX;

  late ValueStream<T?> valueX = _modelX.switchMapWithValue((model) =>
      model?.valueX.mapWithValue((value) => value.getOrNull()) ?? Stream<T?>.empty().publishValueSeeded(null));

  AssetFieldProperty({required super.name}) {
    _modelX = BehaviorSubject.seeded(_getAssetModel());
    withListener((assetId) {
      if (assetId != null) {
        _modelX.value = _getAssetModel();
      }
    });
  }

  Type get assetType => A;

  /// Deletes the currently uploaded asset and sets the value of this property to the id of a newly uploaded asset with
  /// [assetValue].
  Future<void> uploadNewAssetAndSet(T? assetValue) async {
    if (value != null) {
      await locate<AssetModule>().deleteAsset<A>(value!);
      value = null;
    }

    if (assetValue != null) {
      final id = await locate<AssetModule>().uploadAsset<A, T>(assetValue);
      value = id;
    }
  }

  Model<T?>? _getAssetModel() {
    return value.mapIfNonNull((value) => locate<AssetModule>().getAssetModel<A, T>(value));
  }
}
