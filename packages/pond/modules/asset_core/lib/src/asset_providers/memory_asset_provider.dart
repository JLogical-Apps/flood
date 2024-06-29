import 'package:asset_core/src/asset.dart';
import 'package:asset_core/src/asset_path_context.dart';
import 'package:asset_core/src/asset_providers/asset_provider.dart';
import 'package:asset_core/src/asset_reference.dart';
import 'package:model_core/model_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

class MemoryAssetProvider with IsAssetProvider {
  final Map<String, BehaviorSubject<FutureValue<Asset>>> _assetXById = {};

  @override
  AssetReference getById(AssetPathContext context, String id) {
    return AssetReference(
      id: id,
      assetModel: Model.fromValueStream(_assetXById.putIfAbsent(id,
          () => BehaviorSubject.seeded(FutureValue.error('Asset with id [$id] does not exist!', StackTrace.current)))),
    );
  }

  @override
  Future<Asset> onUpload(AssetPathContext context, Asset asset) async {
    final assetX = _assetXById.putIfAbsent(asset.id, () => BehaviorSubject.seeded(FutureValue.empty()));
    final newAsset = assetX.value.maybeWhen(
      onLoaded: (existingAsset) => asset.copyWith(
        metadata: asset.metadata.withCreatedAt(existingAsset.metadata.createdTime),
      ),
      orElse: () => asset,
    );
    assetX.value = FutureValue.loaded(newAsset);

    return asset;
  }

  @override
  Future<void> onDelete(AssetPathContext context, String id) async {
    if (_assetXById[id] == null) {
      throw Exception('Cannot delete non-existing asset! [$id]');
    }
    _assetXById[id]!.value = FutureValue.error('Asset with id [$id] does not exist!', StackTrace.current);
  }
}
