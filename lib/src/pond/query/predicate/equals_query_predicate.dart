import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';

class EqualsQueryPredicate extends AbstractQueryPredicate {
  final String stateField;

  final dynamic isEqualTo;

  const EqualsQueryPredicate({required this.stateField, required this.isEqualTo});

  List<Object?> get props => [stateField, isEqualTo];
}
