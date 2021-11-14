import 'package:jlogical_utils/src/pond/query/predicate/query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class WhereQuery<R extends Record> extends Query<R> {
  final QueryPredicate queryPredicate;

  WhereQuery({required Query parent, required this.queryPredicate}) : super(parent: parent);
}
