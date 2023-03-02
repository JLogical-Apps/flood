import 'package:drop_core/src/query/condition/query_condition.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/record/entity.dart';

class WhereQuery<E extends Entity> extends Query<E> {
  final QueryCondition condition;

  WhereQuery({required Query parent, required this.condition}) : super(parent: parent);

  @override
  String toString() {
    return '$parent | where $condition';
  }

  @override
  List<Object?> get props => [condition];
}
