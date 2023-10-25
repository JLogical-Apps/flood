import 'package:persistence_core/src/crossfile/cross_element.dart';
import 'package:persistence_core/src/crossfile/cross_file.dart';
import 'package:persistence_core/src/data_source.dart';

class RawCrossFileDataSource extends DataSource<List<int>> {
  final CrossFile file;

  RawCrossFileDataSource({required this.file});

  @override
  Stream<List<int>>? getXOrNull() async* {
    if (!await exists()) {
      return;
    }

    yield* file.readX();
  }

  @override
  Future<List<int>?> getOrNull() async {
    if (!await exists()) {
      return null;
    }

    return await file.read();
  }

  @override
  Future<bool> exists() {
    return file.exists();
  }

  @override
  Future<void> set(List<int> data) async {
    await file.ensureCreated();
    await file.write(data);
  }

  @override
  Future<void> delete() async {
    if (!await exists()) {
      return;
    }

    await file.delete();
  }
}
