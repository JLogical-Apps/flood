import 'package:drop_core/src/query/condition/query_condition.dart';

class IsGreaterThanOrEqualToQueryCondition extends QueryCondition {
  final dynamic value;

  IsGreaterThanOrEqualToQueryCondition({required super.stateField, required this.value});

  @override
  String toString() {
    return '$stateField >= $value';
  }

  @override
  List<Object?> get props => super.props + [value];
}
