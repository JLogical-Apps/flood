import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';
import 'package:jlogical_utils/src/persistence/data_source/with_local_data_source.dart';

/// Data source that stores its data locally.
class LocalDataSource<T> extends DataSource<T> with WithLocalDataSource<T> {
  final T? initialData;

  LocalDataSource({this.initialData});
}
