import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:rxdart/rxdart.dart';

import '../../context/app_context.dart';
import '../../property/field_property.dart';
import 'asset.dart';
import 'asset_module.dart';

class AssetFieldProperty<A extends Asset<T>, T> extends FieldProperty<String> {
  BehaviorSubject<A?> _assetX = BehaviorSubject.seeded(null);
  late ValueStream<A?> assetX = _assetX;

  late ValueStream<T?> valueX = _assetX.switchMapWithValue((asset) =>
      asset?.model.valueX.mapWithValue((value) => value.getOrNull()) ?? Stream<T?>.empty().publishValueSeeded(null));

  A? get asset => _assetX.value;

  set asset(A? asset) {
    _assetX.value = asset;
  }

  AssetFieldProperty({required super.name}) {
    withListener((assetId) {
      if (assetId != null) {
        asset = locate<AssetModule>().getAssetProvider<A, T>().from(assetId);
      }
    });
  }

  Type get assetType => A;

  /// Deletes the currently uploaded asset and sets the value of this property to the id of a newly uploaded asset with
  /// [assetValue].
  Future<void> uploadNewAssetAndSet(T? assetValue) async {
    await asset?.deleteIfUploaded();

    asset = null;
    value = null;

    if (assetValue != null) {
      asset = await locate<AssetModule>().getAssetProvider<A, T>().create(assetValue);
      value = asset!.id;
    }
  }

  Future<T?> ensureLoadedAndGet() async {
    return asset?.model.ensureLoadedAndGet();
  }
}
