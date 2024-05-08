import 'package:drop_core/src/query/condition/query_condition.dart';

class IsInQueryCondition extends QueryCondition {
  final List values;

  IsInQueryCondition({required super.stateField, required this.values});

  @override
  String toString() {
    return '$stateField in $values';
  }

  @override
  List<Object?> get props => super.props + [values];
}
