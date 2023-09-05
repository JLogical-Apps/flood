import 'dart:convert';
import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:persistence/src/crossfile/web/web_cross_context.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:utils_core/utils_core.dart';

class WebCrossFile with IsCrossFile {
  @override
  final String path;

  WebCrossFile({required this.path});

  String? get parent {
    final parent = dirname(path);
    if (parent == '.') {
      return null;
    }

    return parent;
  }

  @override
  Future<void> create() async {
    await _update('');
  }

  @override
  Future<void> delete() async {
    await _update(null);
  }

  @override
  Future<bool> exists() async {
    return await _getValue() != null;
  }

  @override
  Future<Uint8List> read() async {
    final raw = await _getValue();
    return Uint8List.fromList(utf8.encode(raw));
  }

  @override
  Stream<Uint8List> readX() async* {
    yield* WebCrossContext.global.getRootX().map((root) => root.getPathed(path));
  }

  @override
  Future<void> write(List<int> bytes) async {
    await _update(utf8.decode(bytes));
  }

  Future<void> _update(String? data) async {
    final root = await WebCrossContext.global.getRoot();

    if (data == null) {
      root.removePathed(path);
    } else {
      root.updatePathed(path, (_) => data);
    }

    await WebCrossContext.global.updateRoot(root);
  }

  Future<dynamic> _getValue() async {
    final root = await WebCrossContext.global.getRoot();
    return root.getPathed(path);
  }
}
