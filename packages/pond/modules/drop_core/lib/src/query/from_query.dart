import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:runtime_type/type.dart';
import 'package:utils_core/utils_core.dart';

class FromQuery<E extends Entity> extends Query<E> {
  final Type entityType;

  FromQuery({required this.entityType}) : super(parent: null);

  @override
  String prettyPrint(DropCoreContext context) {
    if (entityType == typeOf<Entity<ValueObject>>()) {
      return 'from all';
    }
    return 'from ${context.getRuntimeTypeRuntime(entityType).name}';
  }

  @override
  List<Object?> get props => [entityType];
}
