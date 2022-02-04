import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';

class GreaterThanQueryPredicate extends AbstractQueryPredicate {
  final String stateField;

  final dynamic isGreaterThan;

  const GreaterThanQueryPredicate({required this.stateField, required this.isGreaterThan});

  List<Object?> get props => [stateField, isGreaterThan];
}
