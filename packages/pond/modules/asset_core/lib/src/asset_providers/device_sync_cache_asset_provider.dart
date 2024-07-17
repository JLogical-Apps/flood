import 'package:asset_core/asset_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:model_core/model_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

const timeoutDuration = Duration(seconds: 4);

class DeviceSyncCacheAssetProvider with IsAssetProviderWrapper {
  final AssetProvider sourceAssetProvider;
  final AssetProvider cacheAssetProvider;

  final Map<(AssetPathContext, String), AssetReference> _sourceAssetReferenceById = {};
  final Map<(AssetPathContext, String), AssetReference> _cacheAssetReferenceById = {};

  final Map<(AssetPathContext, String), BehaviorSubject<FutureValue<AssetMetadata>>> _assetMetadataXById = {};
  final Map<(AssetPathContext, String), BehaviorSubject<FutureValue<Asset>>> _assetXById = {};

  DeviceSyncCacheAssetProvider({required this.sourceAssetProvider, required this.cacheAssetProvider});

  @override
  AssetProvider get assetProvider => sourceAssetProvider;

  @override
  AssetReference getById(AssetPathContext context, String id) {
    final key = (context, id);
    return AssetReference(
      id: id,
      assetMetadataModel: Model.fromValueStream(
        _assetMetadataXById.putIfAbsent(key, () => BehaviorSubject.seeded(FutureValue.empty())),
        onLoad: () => getLatestAssetMetadata(context, id),
      ),
      assetModel: Model.fromValueStream(
        _assetXById.putIfAbsent(key, () => BehaviorSubject.seeded(FutureValue.empty())),
        onLoad: () async {
          await getLatestAssetMetadata(context, id, waitForAsset: true);
        },
      ),
    );
  }

  Future<AssetMetadata?> getLatestAssetMetadata(
    AssetPathContext context,
    String id, {
    bool waitForAsset = false,
  }) async {
    final key = (context, id);
    if (_assetMetadataXById[key]?.value.isLoaded ?? false) {
      return _assetMetadataXById[key]!.value.getOrNull()!;
    }

    final cacheAssetReference =
        _cacheAssetReferenceById.putIfAbsent(key, () => cacheAssetProvider.getById(context, id));

    final cachedAssetMetadata = await guardAsync(() => cacheAssetReference.assetMetadataModel.getOrLoad());
    if (cachedAssetMetadata != null) {
      _assetMetadataXById[key]!.value = FutureValue.loaded(cachedAssetMetadata);
      if (_assetXById[key]?.value.isLoaded != true) {
        final cacheAsset = await guardAsync(() => cacheAssetReference.assetModel.getOrLoad());
        if (cacheAsset != null) {
          _assetXById.putIfAbsent(key, () => BehaviorSubject.seeded(FutureValue.empty())).value =
              FutureValue.loaded(cacheAsset);
        }
      }
    }

    final sourceAssetReference =
        _sourceAssetReferenceById.putIfAbsent(key, () => sourceAssetProvider.getById(context, id));
    final sourceAssetMetadata =
        await guardAsync(() => sourceAssetReference.assetMetadataModel.getOrLoad().timeout(timeoutDuration));
    if (sourceAssetMetadata != null) {
      _assetMetadataXById[key]!.value = FutureValue.loaded(sourceAssetMetadata);
    }

    final needsUpdating = cachedAssetMetadata == null ||
        (sourceAssetMetadata != null &&
            cachedAssetMetadata.updatedTime.isBefore(sourceAssetMetadata.updatedTime.subtract(Duration(seconds: 30))));
    if (needsUpdating) {
      if (waitForAsset) {
        await downloadSource(context, id);
      } else {
        downloadSource(context, id);
      }
    }

    return sourceAssetMetadata;
  }

  Future<void> downloadSource(AssetPathContext context, String id) async {
    final key = (context, id);
    final sourceAsset = await guardAsync(() => sourceAssetProvider.getById(context, id).assetModel.getOrLoad());
    if (sourceAsset == null) {
      return;
    }

    await cacheAssetProvider.upload(context, sourceAsset);

    _assetMetadataXById.putIfAbsent(key, () => BehaviorSubject.seeded(FutureValue.empty())).value =
        FutureValue.loaded(sourceAsset.metadata);
    _assetXById.putIfAbsent(key, () => BehaviorSubject.seeded(FutureValue.empty())).value =
        FutureValue.loaded(sourceAsset);
  }

  @override
  Future<Asset> onUpload(AssetPathContext context, Asset asset) async {
    final key = (context, asset.id);
    if (context.metadata[forceSourceUpdateField] == true) {
      return await sourceAssetProvider.upload(context, asset);
    }

    _assetXById.putIfAbsent(key, () => BehaviorSubject.seeded(FutureValue.loaded(asset))).value =
        FutureValue.loaded(asset);
    _assetMetadataXById.putIfAbsent(key, () => BehaviorSubject.seeded(FutureValue.loaded(asset.metadata))).value =
        FutureValue.loaded(asset.metadata);

    final newAsset = await cacheAssetProvider.upload(context, asset);

    await context.corePondContext.syncCoreComponent.registerAction(UploadAssetSyncActionEntity()
      ..set(UploadAssetSyncAction()
        ..assetPathProperty.set(AssetProviderMetaModifier.getModifier(sourceAssetProvider).getPath(
          sourceAssetProvider,
          AssetPathContext(context: context.context, values: {State.idField: entityIdWildcard}),
        )!)
        ..entityIdProperty.set(context.entityId)
        ..idProperty.set(asset.id)));

    return newAsset;
  }

  @override
  Future<void> onDelete(AssetPathContext context, String id) async {
    final key = (context, id);
    if (context.metadata[forceSourceUpdateField] == true) {
      await sourceAssetProvider.delete(context, id);
      return;
    }

    await context.corePondContext.syncCoreComponent.registerAction(DeleteAssetSyncActionEntity()
      ..set(DeleteAssetSyncAction()
        ..assetPathProperty.set(AssetProviderMetaModifier.getModifier(sourceAssetProvider).getPath(sourceAssetProvider,
            AssetPathContext(context: context.context, values: {State.idField: entityIdWildcard}))!)
        ..entityIdProperty.set(context.entityId)
        ..idProperty.set(id)));

    await cacheAssetProvider.delete(context, id);
    _assetMetadataXById[key]?.value = FutureValue.empty();
    _assetMetadataXById.remove(key);
    _assetXById[key]?.value = FutureValue.empty();
    _assetXById.remove(key);
  }

  @override
  Future<void> onReset() async {
    await Future.wait([sourceAssetProvider.reset(), cacheAssetProvider.reset()]);
  }
}
