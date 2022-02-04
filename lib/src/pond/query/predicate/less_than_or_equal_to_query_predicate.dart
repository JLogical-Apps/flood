import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';

class LessThanOrEqualToQueryPredicate extends AbstractQueryPredicate {
  final String stateField;

  final dynamic isLessThanOrEqualTo;

  const LessThanOrEqualToQueryPredicate({required this.stateField, required this.isLessThanOrEqualTo});

  List<Object?> get props => [stateField, isLessThanOrEqualTo];
}
