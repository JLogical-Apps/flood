import 'package:asset/asset.dart';
import 'package:firebase/src/persistence/firebase_storage_data_source.dart';
import 'package:firebase/src/persistence/firebase_storage_metadata_data_source.dart';
import 'package:path/path.dart';
import 'package:persistence/persistence.dart';
import 'package:pond_core/pond_core.dart';

class FirebaseStorageAssetDataSource with IsDataSource<Asset> {
  final CorePondContext context;
  final String path;

  late FirebaseStorageDataSource dataSource = FirebaseStorageDataSource(context: context, path: path);
  late FirebaseStorageMetadataDataSource metadataDataSource =
      FirebaseStorageMetadataDataSource(context: context, path: path);

  FirebaseStorageAssetDataSource({required this.context, required this.path});

  @override
  Stream<Asset> getXOrNull() async* {
    yield await getOrNull();
  }

  @override
  Future<bool> exists() async {
    return await dataSource.exists();
  }

  @override
  Future<Asset> getOrNull() async {
    final value = await dataSource.get();
    final metadata = await metadataDataSource.get();
    return Asset(
      id: basename(path),
      value: value,
      metadata: metadata,
    );
  }

  @override
  Future<void> set(Asset data) async {
    await dataSource.set(data.value);
    await metadataDataSource.set(data.metadata);
  }

  @override
  Future<void> delete() async {
    await dataSource.delete();
  }
}
