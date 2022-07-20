import 'dart:async';

import 'data_source.dart';

class CustomDataSource<T> extends DataSource<T> {
  final FutureOr<T?> Function() onGet;
  final FutureOr<void> Function(T) onSave;
  final FutureOr<void> Function() onDelete;

  CustomDataSource({required this.onGet, required this.onSave, required this.onDelete});

  @override
  Future<void> delete() async {
    return await onDelete();
  }

  @override
  Future<T?> getData() async {
    return await onGet();
  }

  @override
  Future<void> saveData(T data) async {
    return await onSave(data);
  }
}
