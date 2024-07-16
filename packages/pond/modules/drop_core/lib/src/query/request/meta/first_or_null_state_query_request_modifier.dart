import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/query/meta/query_modifier.dart';
import 'package:drop_core/src/query/request/meta/query_request_modifier.dart';

class FirstOrNullStateQueryRequestModifier extends QueryRequestMetaModifier<FirstOrNullStateQueryRequest> {
  @override
  String? getSingleDocumentId(FirstOrNullStateQueryRequest queryRequest) {
    return QueryMetaModifier.findSingleDocumentId(queryRequest.query);
  }
}
