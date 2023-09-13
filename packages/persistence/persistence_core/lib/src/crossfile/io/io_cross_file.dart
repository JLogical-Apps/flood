import 'dart:io';
import 'dart:typed_data';

import 'package:persistence_core/src/crossfile/cross_file.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

class IoCrossFile with IsCrossFile {
  final File file;

  IoCrossFile({required this.file});

  final BehaviorSubject _refreshSubject = BehaviorSubject.seeded(null);

  @override
  Future<void> create() async {
    await file.create(recursive: true);
    _refreshSubject.value = null;
  }

  @override
  Future<void> delete() async {
    await file.delete();
    _refreshSubject.value = null;
  }

  @override
  Future<bool> exists() async {
    return await file.exists();
  }

  @override
  String get path => file.path;

  @override
  Future<Uint8List> read() async {
    return await file.readAsBytes();
  }

  @override
  Stream<Uint8List> readX() {
    return Rx.merge<dynamic>([
      file.watch(),
      _refreshSubject,
    ]).map((_) => file.readAsBytesSync());
  }

  @override
  Future<void> write(List<int> bytes) async {
    await file.ensureCreated();
    await file.writeAsBytes(bytes);
    _refreshSubject.value = null;
  }
}
