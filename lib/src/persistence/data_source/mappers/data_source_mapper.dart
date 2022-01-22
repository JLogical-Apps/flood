import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';
import 'package:jlogical_utils/src/persistence/data_source/mappers/with_mapper_data_source.dart';

class DataSourceMapper<P, T> extends DataSource<T> with WithMapperDataSource<P, T> {
  final DataSource<P> parent;

  final P Function(T obj) onSave;
  final T? Function(P? persisted) onLoad;

  DataSourceMapper({required this.parent, required this.onSave, required this.onLoad});

  @override
  T? loadMapped(P? persisted) {
    return onLoad(persisted);
  }

  @override
  P saveMapped(T obj) {
    return onSave(obj);
  }
}
