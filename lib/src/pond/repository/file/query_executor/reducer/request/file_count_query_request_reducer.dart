import 'dart:async';

import 'package:jlogical_utils/src/pond/query/request/count_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import 'abstract_file_query_request_reducer.dart';

class FileCountQueryRequestReducer<R extends Record>
    extends AbstractFileQueryRequestReducer<CountQueryRequest<R>, R, int> {
  @override
  Future<int> reduce({required Iterable<State> accumulation, required CountQueryRequest<R> queryRequest}) async {
    return accumulation.length;
  }
}
