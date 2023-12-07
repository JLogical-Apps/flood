import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/record/entity.dart';

class OrderByQuery<E extends Entity> extends Query<E> {
  final String stateField;
  final OrderByType type;

  OrderByQuery({required Query parent, required this.stateField, required this.type}) : super(parent: parent);

  @override
  String prettyPrint(DropCoreContext context) {
    return '${parent!.prettyPrint(context)} | order $stateField $type';
  }

  @override
  List<Object?> get props => [parent, stateField, type];
}

enum OrderByType {
  descending,
  ascending,
}
