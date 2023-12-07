import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/condition/query_condition.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/record/entity.dart';

class WhereQuery<E extends Entity> extends Query<E> {
  final QueryCondition condition;

  WhereQuery({required Query parent, required this.condition}) : super(parent: parent);

  @override
  String prettyPrint(DropCoreContext context) {
    return '${parent!.prettyPrint(context)} | where $condition';
  }

  @override
  List<Object?> get props => [parent, condition];
}
