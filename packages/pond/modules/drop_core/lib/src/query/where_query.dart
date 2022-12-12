import 'package:drop_core/src/query/condition/query_condition.dart';
import 'package:drop_core/src/query/query.dart';

class WhereQuery extends Query {
  final QueryCondition condition;

  WhereQuery({required Query parent, required this.condition}) : super(parent: parent);
}
