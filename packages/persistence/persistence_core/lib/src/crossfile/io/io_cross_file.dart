import 'dart:io';
import 'dart:typed_data';

import 'package:persistence_core/src/crossfile/cross_file.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';
import 'package:utils_core/utils_core.dart';

class IoCrossFile with IsCrossFile {
  static final Map<String, Lock> _lockByPath = {};

  final File file;

  IoCrossFile({required this.file});

  final BehaviorSubject _refreshSubject = BehaviorSubject.seeded(null);

  @override
  Future<void> create() async {
    await withLockedFile(() => file.create(recursive: true));
    _refreshSubject.value = null;
  }

  @override
  Future<void> delete() async {
    await withLockedFile(() => file.delete());
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
    return await withLockedFile(() => file.readAsBytes());
  }

  @override
  Stream<Uint8List> readX() {
    return Rx.merge<dynamic>([
      file.watch(),
      _refreshSubject,
    ]).asyncMap((_) => withLockedFile(() => file.readAsBytes()));
  }

  @override
  Future<void> write(List<int> bytes) async {
    await withLockedFile(() async {
      await file.ensureCreated();
      await file.writeAsBytes(bytes);
    });
    _refreshSubject.value = null;
  }

  Future<T> withLockedFile<T>(Future<T> Function() function) async {
    final lock = _lockByPath.putIfAbsent(file.path, () => Lock());
    final result = await lock.synchronized(function);
    _lockByPath.remove(file.path);
    return result;
  }
}
