import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';

class ContainsQueryPredicate extends AbstractQueryPredicate {
  final String stateField;

  final dynamic contains;

  const ContainsQueryPredicate({required this.stateField, required this.contains});

  List<Object?> get props => [stateField, contains];

  @override
  String toString() {
    return '$stateField contains $contains';
  }
}
