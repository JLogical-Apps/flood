import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/record/entity.dart';

class FromQuery<E extends Entity> extends Query<E> {
  final Type entityType;

  FromQuery({required this.entityType}) : super(parent: null);

  @override
  String toString() {
    return 'from $entityType';
  }

  @override
  List<Object?> get props => [entityType];
}
