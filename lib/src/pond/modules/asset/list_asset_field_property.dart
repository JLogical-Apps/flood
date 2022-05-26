import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:rxdart/rxdart.dart';

import '../../../model/export_core.dart';
import '../../context/app_context.dart';
import '../../property/list_field_property.dart';
import 'asset.dart';
import 'asset_module.dart';

class ListAssetFieldProperty<A extends Asset<T>, T> extends ListFieldProperty<String> {
  late BehaviorSubject<List<Model<T?>>> _modelsX;

  late ValueStream<List<T?>> valuesX =
      _modelsX.mapWithValue((models) => models.map((model) => model.value.getOrNull()).toList());

  ListAssetFieldProperty({required super.name}) {
    _modelsX = BehaviorSubject.seeded(_getAssetModels());
    withListener((assetIds) {
      _modelsX.value = _getAssetModels();
    });
  }

  Type get assetType => A;

  Future<void> uploadNewAsset(T assetValue, {String? suffix}) async {
    final id = await locate<AssetModule>().uploadAsset<A, T>(assetValue, suffix: suffix);
    value = [...?value, id];
  }

  Future<void> deleteAsset(String assetId) async {
    if (value?.contains(assetId) != true) {
      throw Exception('Cannot find asset with id [$assetId] in this property: [$this]');
    }

    await locate<AssetModule>().deleteAsset<A>(assetId);
    value = [...?value]..remove(assetId);
  }

  List<Model<T?>> _getAssetModels() {
    return value?.map((assetId) => locate<AssetModule>().getAssetModel<A, T>(assetId)).toList() ?? [];
  }
}
