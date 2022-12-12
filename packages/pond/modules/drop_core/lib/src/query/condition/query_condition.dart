import 'package:drop_core/src/query/condition/query_condition_builder.dart';

abstract class QueryCondition {
  final String stateField;

  QueryCondition({required this.stateField});

  static QueryConditionBuilder field(String stateField) {
    return QueryConditionBuilder(stateField: stateField);
  }
}
