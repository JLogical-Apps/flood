import 'package:drop_core/src/query/condition/query_condition.dart';

class IsNullQueryCondition extends QueryCondition {
  IsNullQueryCondition({required super.stateField});

  @override
  String toString() {
    return '$stateField is null';
  }
}
