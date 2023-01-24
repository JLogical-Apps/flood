import 'package:drop_core/src/query/condition/query_condition.dart';

class IsGreaterThanQueryCondition extends QueryCondition {
  final dynamic value;

  IsGreaterThanQueryCondition({required super.stateField, required this.value});

  @override
  String toString() {
    return '$stateField > $value';
  }
}
