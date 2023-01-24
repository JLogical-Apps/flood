import 'package:drop_core/src/query/condition/query_condition.dart';

class IsNonNullQueryCondition extends QueryCondition {
  IsNonNullQueryCondition({required super.stateField});

  @override
  String toString() {
    return '$stateField is not null';
  }
}
