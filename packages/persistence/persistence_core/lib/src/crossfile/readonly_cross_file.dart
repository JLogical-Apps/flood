import 'package:persistence_core/src/crossfile/cross_file.dart';

class ReadonlyCrossFile with IsCrossFileWrapper {
  @override
  final CrossFile crossFile;

  ReadonlyCrossFile({required this.crossFile});

  @override
  Future<void> create() {
    throw Exception('Cannot create readonly file!');
  }

  @override
  Future<void> write(List<int> bytes) {
    throw Exception('Cannot write to readonly file!');
  }

  @override
  Future<void> delete() {
    throw Exception('Cannot delete readonly file!');
  }
}
