import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';

class LessThanQueryPredicate extends AbstractQueryPredicate {
  final String stateField;

  final dynamic isLessThan;

  const LessThanQueryPredicate({required this.stateField, required this.isLessThan});
}
