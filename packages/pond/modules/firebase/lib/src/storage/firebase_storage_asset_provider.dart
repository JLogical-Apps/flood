import 'dart:typed_data';

import 'package:asset/asset.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:model_core/model_core.dart';
import 'package:persistence/persistence.dart';
import 'package:pond/pond.dart';

class FirebaseStorageAssetProvider with IsAssetProvider {
  final CorePondContext context;
  final String path;

  final Map<String, Model<Uint8List>> _bytesModelById = {};
  final Map<String, Model<AssetMetadata>> _metadataModelById = {};

  FirebaseStorageAssetProvider({required this.context, required this.path});

  Reference get reference => context.firebaseCoreComponent.storage.ref(path);

  @override
  AssetReference getById(String id) {
    final metadataModel = _metadataModelById.putIfAbsent(
      id,
      () => DataSource.static.firebaseStorageMetadata(context: context, path: '$path/$id').asModel(),
    );
    final bytesModel = _bytesModelById.putIfAbsent(
      id,
      () => DataSource.static.firebaseStorage(context: context, path: '$path/$id').asModel(),
    );
    return AssetReference(
      id: id,
      assetMetadataModel: metadataModel,
      assetModel: Model.union([metadataModel, bytesModel]).map((List results) {
        final [AssetMetadata metadata, Uint8List bytes] = results;
        return Asset(
          id: id,
          value: bytes,
          metadata: metadata,
        );
      }),
    );
  }

  @override
  Future<List<String>> onListIds() {
    throw UnimplementedError();
  }

  @override
  Future<Asset> onUpload(Asset asset) async {
    await DataSource.static.firebaseStorageAsset(context: context, path: '$path/${asset.id}').set(asset);
    await _bytesModelById[asset.id]?.load();
    await _metadataModelById[asset.id]?.load();
    return asset;
  }

  @override
  Future<void> onDelete(String id) async {
    await DataSource.static.firebaseStorageAsset(context: context, path: '$path/$id').delete();
    _bytesModelById.remove(id);
    _metadataModelById.remove(id);
  }
}
