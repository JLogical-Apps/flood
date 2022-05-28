import 'dart:typed_data';

import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:rxdart/rxdart.dart';

import '../../../model/export_core.dart';
import '../../context/app_context.dart';
import '../../property/list_field_property.dart';
import 'asset.dart';
import 'asset_module.dart';

class ListAssetFieldProperty extends ListFieldProperty<String> {
  late BehaviorSubject<List<Model<Asset?>>> _modelsX;

  late ValueStream<List<Uint8List?>> valuesX =
      _modelsX.mapWithValue((models) => models.map((model) => model.value.getOrNull()?.value).toList());

  ListAssetFieldProperty({required super.name}) {
    _modelsX = BehaviorSubject.seeded(getAssetModels());
    withListener((assetIds) {
      _modelsX.value = getAssetModels();
    });
  }

  Future<void> uploadNewAsset(Asset asset) async {
    final id = await locate<AssetModule>().uploadAsset(asset);
    value = [...?value, id];
  }

  Future<void> deleteAsset(String assetId) async {
    if (value?.contains(assetId) != true) {
      throw Exception('Cannot find asset with id [$assetId] in this property: [$this]');
    }

    await locate<AssetModule>().deleteAsset(assetId);
    value = [...?value]..remove(assetId);
  }

  List<Model<Asset?>> getAssetModels() {
    return value?.map((assetId) => locate<AssetModule>().getAssetModel(assetId)).toList() ?? [];
  }

  Future<List<Asset?>> getAssets() async {
    return await Future.wait(getAssetModels().map((model) => model.ensureLoadedAndGet()));
  }
}
