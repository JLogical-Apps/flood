import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';

class GreaterThanOrEqualToQueryPredicate extends AbstractQueryPredicate {
  final String stateField;

  final dynamic isGreaterThanOrEqualTo;

  const GreaterThanOrEqualToQueryPredicate({required this.stateField, required this.isGreaterThanOrEqualTo});

  List<Object?> get props => [stateField, isGreaterThanOrEqualTo];
}
