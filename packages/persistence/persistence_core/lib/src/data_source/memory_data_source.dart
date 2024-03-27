import 'package:persistence_core/src/data_source/data_source.dart';
import 'package:rxdart/rxdart.dart';

class MemoryDataSource<T> with IsDataSource<T> {
  BehaviorSubject<T?> dataX;

  MemoryDataSource({T? initialData}) : dataX = BehaviorSubject.seeded(initialData);

  @override
  Stream<T>? getXOrNull() {
    return dataX.value == null ? null : dataX.takeWhile((data) => data != null).map((data) => data!);
  }

  @override
  Future<T?> getOrNull() async {
    return dataX.value;
  }

  @override
  Future<void> set(T data) async {
    dataX.value = data;
  }

  @override
  Future<void> delete() async {
    dataX.value = null;
  }
}
