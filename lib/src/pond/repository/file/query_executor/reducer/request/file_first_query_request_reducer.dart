import 'dart:async';

import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/pond/query/reducer/entity_inflater.dart';
import 'package:jlogical_utils/src/pond/query/reducer/request/with_first_query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/first_or_null_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import 'abstract_file_query_request_reducer.dart';

class FileFirstOrNullQueryRequestReducer<R extends Record>
    extends AbstractFileQueryRequestReducer<FirstOrNullQueryRequest<R>, R, R?>
    with WithFirstQueryRequestReducer<R, Iterable<State>> {
  @override
  final EntityInflater entityInflater;

  FileFirstOrNullQueryRequestReducer({required this.entityInflater});

  @override
  FutureOr<State?> getState(Iterable<State> accumulation) {
    return accumulation.firstOrNull;
  }
}
