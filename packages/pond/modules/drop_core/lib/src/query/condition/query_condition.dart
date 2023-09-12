import 'package:drop_core/src/query/condition/query_condition_builder.dart';
import 'package:equatable/equatable.dart';

abstract class QueryCondition with EquatableMixin {
  final String stateField;

  QueryCondition({required this.stateField});

  static QueryConditionBuilder field(String stateField) {
    return QueryConditionBuilder(stateField: stateField);
  }

  @override
  List<Object?> get props => [stateField];
}
