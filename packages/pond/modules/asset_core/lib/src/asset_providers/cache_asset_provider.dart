import 'package:asset_core/src/asset.dart';
import 'package:asset_core/src/asset_metadata.dart';
import 'package:asset_core/src/asset_path_context.dart';
import 'package:asset_core/src/asset_providers/asset_provider.dart';
import 'package:asset_core/src/asset_reference.dart';
import 'package:model_core/model_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

class CacheAssetProvider with IsAssetProviderWrapper {
  final Map<String, AssetReference> _assetReferenceById = {};
  final Map<String, BehaviorSubject<FutureValue<AssetMetadata>>> _assetMetadataXById = {};
  final Map<String, BehaviorSubject<FutureValue<Asset>>> _assetXById = {};

  @override
  final AssetProvider assetProvider;

  CacheAssetProvider({required this.assetProvider});

  @override
  AssetReference getById(AssetPathContext context, String id) {
    final sourceAssetReference = _assetReferenceById.putIfAbsent(id, () => assetProvider.getById(context, id));

    return AssetReference(
      id: id,
      assetMetadataModel: Model.fromValueStream(_assetMetadataXById.putIfAbsent(id, () {
        () async {
          final assetMetadata = await guardAsync(() => sourceAssetReference.assetMetadataModel.getOrLoad());
          if (assetMetadata != null) {
            _assetMetadataXById[id]!.value = FutureValue.loaded(assetMetadata);
          }
        }();
        return BehaviorSubject.seeded(FutureValue.empty());
      })),
      assetModel: Model.fromValueStream(_assetXById.putIfAbsent(id, () {
        () async {
          final asset = await guardAsync(() => sourceAssetReference.assetModel.getOrLoad());
          if (asset != null) {
            _assetXById[id]!.value = FutureValue.loaded(asset);
          }
        }();
        return BehaviorSubject.seeded(FutureValue.empty());
      })),
    );
  }

  @override
  Future<Asset> onUpload(AssetPathContext context, Asset asset) async {
    final sourceAsset = await assetProvider.upload(context, asset);

    final assetX = _assetXById.putIfAbsent(asset.id, () => BehaviorSubject.seeded(FutureValue.empty()));
    final newAsset = assetX.value.maybeWhen(
      onLoaded: (existingAsset) => sourceAsset.copyWith(
        metadata: sourceAsset.metadata.withCreatedAt(existingAsset.metadata.createdTime),
      ),
      orElse: () => sourceAsset,
    );
    assetX.value = FutureValue.loaded(newAsset);
    _assetMetadataXById.putIfAbsent(asset.id, () => BehaviorSubject.seeded(FutureValue.empty())).value =
        FutureValue.loaded(newAsset.metadata);

    return newAsset;
  }

  @override
  Future<void> onDelete(AssetPathContext context, String id) async {
    await assetProvider.delete(context, id);
    _assetMetadataXById[id]?.value = FutureValue.empty();
    _assetMetadataXById.remove(id);
    _assetXById[id]?.value = FutureValue.empty();
    _assetXById.remove(id);
  }
}
