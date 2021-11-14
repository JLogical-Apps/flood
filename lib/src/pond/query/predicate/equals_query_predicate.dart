import 'package:jlogical_utils/src/pond/query/predicate/query_predicate.dart';

class EqualsQueryPredicate extends QueryPredicate {
  final String stateField;

  final dynamic isEqualTo;

  const EqualsQueryPredicate({required this.stateField, required this.isEqualTo});
}
