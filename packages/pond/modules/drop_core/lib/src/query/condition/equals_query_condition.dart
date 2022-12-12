import 'package:drop_core/src/query/condition/query_condition.dart';

class EqualsQueryCondition extends QueryCondition {
  final dynamic value;

  EqualsQueryCondition({required super.stateField, required this.value});
}
