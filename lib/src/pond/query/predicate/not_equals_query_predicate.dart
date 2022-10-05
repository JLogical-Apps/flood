import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';

class NotEqualsQueryPredicate extends AbstractQueryPredicate {
  final String stateField;

  final dynamic isNotEqualTo;

  const NotEqualsQueryPredicate({required this.stateField, required this.isNotEqualTo});

  List<Object?> get props => [stateField, isNotEqualTo];

  @override
  String toString() {
    return '$stateField != $isNotEqualTo';
  }
}
