import 'package:drop_core/src/query/condition/query_condition.dart';

class IsLessThanQueryCondition extends QueryCondition {
  final dynamic value;

  IsLessThanQueryCondition({required super.stateField, required this.value});

  @override
  String toString() {
    return '$stateField < $value';
  }

  @override
  List<Object?> get props => super.props + [value];
}
