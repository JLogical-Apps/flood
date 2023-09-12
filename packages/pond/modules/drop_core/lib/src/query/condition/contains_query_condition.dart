import 'package:drop_core/src/query/condition/query_condition.dart';

class ContainsQueryCondition extends QueryCondition {
  final dynamic value;

  ContainsQueryCondition({required super.stateField, required this.value});

  @override
  String toString() {
    return '$stateField contains $value';
  }

  @override
  List<Object?> get props => super.props + [value];
}
