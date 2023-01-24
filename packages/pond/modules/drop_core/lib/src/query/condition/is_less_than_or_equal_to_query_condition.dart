import 'package:drop_core/src/query/condition/query_condition.dart';

class IsLessThanOrEqualToQueryCondition extends QueryCondition {
  final dynamic value;

  IsLessThanOrEqualToQueryCondition({required super.stateField, required this.value});

  @override
  String toString() {
    return '$stateField <= $value';
  }
}
