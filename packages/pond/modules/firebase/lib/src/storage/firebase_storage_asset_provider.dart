import 'dart:typed_data';

import 'package:asset/asset.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:model_core/model_core.dart';
import 'package:persistence/persistence.dart';
import 'package:pond/pond.dart';
import 'package:utils/utils.dart';

class FirebaseStorageAssetProvider with IsAssetProvider {
  final CorePondContext corePondContext;
  final String Function(AssetPathContext pathContext) pathGetter;

  final Map<String, Model<Uint8List>> _bytesModelById = {};
  final Map<String, Model<AssetMetadata>> _metadataModelById = {};

  FirebaseStorageAssetProvider({required this.corePondContext, required this.pathGetter});

  Reference getReference(AssetPathContext context) =>
      corePondContext.firebaseCoreComponent.storage.ref(pathGetter(context));

  Model<AssetMetadata> getMetadataModel(AssetPathContext context, String id) {
    final path = pathGetter(context);
    return _metadataModelById.putIfAbsent(
      id,
      () => DataSource.static.firebaseStorageMetadata(context: corePondContext, path: '$path/$id').asModel(),
    );
  }

  @override
  AssetReference getById(AssetPathContext context, String id) {
    final path = pathGetter(context);
    final metadataModel = getMetadataModel(context, id);
    final bytesModel = _bytesModelById.putIfAbsent(
      id,
      () => DataSource.static.firebaseStorage(context: corePondContext, path: '$path/$id').asModel(),
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
  Future<Asset> onUpload(AssetPathContext context, Asset asset) async {
    final path = pathGetter(context);
    await DataSource.static.firebaseStorageAsset(context: corePondContext, path: '$path/${asset.id}').set(asset);
    final metadata = (await getMetadataModel(context, asset.id).load()).getOrNull();
    if (metadata != null) {
      asset = asset.copyWith(metadata: metadata);
    }
    return asset;
  }

  @override
  Future<void> onDelete(AssetPathContext context, String id) async {
    final path = pathGetter(context);
    await DataSource.static.firebaseStorageAsset(context: corePondContext, path: '$path/$id').delete();
    _bytesModelById.remove(id);
    _metadataModelById.remove(id);
  }
}
