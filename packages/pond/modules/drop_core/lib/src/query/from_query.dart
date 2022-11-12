import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/record/entity.dart';

class FromQuery<E extends Entity> extends Query<E> {
  FromQuery() : super(parent: null);
}
