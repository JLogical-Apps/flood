import 'package:persistence_core/src/crossfile/cross_directory.dart';
import 'package:persistence_core/src/crossfile/cross_element.dart';
import 'package:persistence_core/src/data_source.dart';

class CrossDirectoryDataSource extends DataSource<List<CrossElement>?> {
  final CrossDirectory directory;

  CrossDirectoryDataSource({required this.directory});

  @override
  Stream<List<CrossElement>?>? getXOrNull() async* {
    yield* directory.listX();
  }

  @override
  Future<List<CrossElement>?> getOrNull() async {
    if (!await exists()) {
      return null;
    }

    return await directory.listOrNull();
  }

  @override
  Future<bool> exists() {
    return directory.exists();
  }

  @override
  Future<void> set(List<CrossElement>? data) async {
    throw Exception('Cannot set the data for a CrossDirectoryDataSource!');
  }

  @override
  Future<void> delete() async {
    if (!await exists()) {
      return;
    }

    await directory.delete();
  }
}
