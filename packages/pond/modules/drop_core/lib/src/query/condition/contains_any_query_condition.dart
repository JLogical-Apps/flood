import 'package:drop_core/src/query/condition/query_condition.dart';

class ContainsAnyQueryCondition extends QueryCondition {
  final List values;

  ContainsAnyQueryCondition({required super.stateField, required this.values});

  @override
  String toString() {
    return '$stateField contains-any $values';
  }

  @override
  List<Object?> get props => super.props + [values];
}
