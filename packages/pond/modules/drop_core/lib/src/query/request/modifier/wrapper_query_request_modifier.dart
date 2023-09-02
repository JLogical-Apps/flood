import 'package:drop_core/src/query/request/modifier/query_request_modifier.dart';
import 'package:drop_core/src/query/request/query_request.dart';

class WrapperQueryRequestModifier extends QueryRequestModifier<QueryRequestWrapper> {
  final QueryRequestModifier? Function(QueryRequest queryRequest) queryRequestModifierGetter;

  WrapperQueryRequestModifier({required this.queryRequestModifierGetter});

  @override
  bool getIsWithoutCache(QueryRequestWrapper queryRequest) {
    return queryRequestModifierGetter(queryRequest.queryRequest)?.getIsWithoutCache(queryRequest.queryRequest) ?? false;
  }
}
