import '../../../model/export_core.dart';
import '../../../persistence/data_source/data_source.dart';

abstract class Asset<T> {
  /// Whether this asset has been uploaded yet.
  bool isOnlyLocal = true;

  final String id;

  final DataSource<T> dataSource;

  late final Model<T> model = Model(
    loader: () async => (await dataSource.getData()) ?? (throw Exception('No value in the data source!')),
  );

  T? get value => model.getOrNull();

  set value(T? value) {
    if (value == null) {
      model.clear();
    } else {
      model.setLoaded(value);
    }
  }

  Asset({required this.id, required this.isOnlyLocal, required this.dataSource});

  Future<void> save() async {
    isOnlyLocal = false;
    await dataSource.saveData(model.getOrNull() ?? (throw Exception('Cannot save no value! Use `delete` instead.')));
  }

  Future<void> delete() async {
    isOnlyLocal = true;
    model.clear();
    await dataSource.delete();
  }

  Future<void> deleteIfUploaded() async {
    if (!isOnlyLocal) {
      await delete();
    }
  }

  Future<void> uploadIfNonexistent() async {
    if (value == null) {
      throw Exception('Cannot upload with no value!');
    }

    if (await dataSource.exists()) {
      return;
    }

    await save();
  }
}
