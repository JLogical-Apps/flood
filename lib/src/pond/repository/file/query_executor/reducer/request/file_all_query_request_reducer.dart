import 'dart:async';

import 'package:jlogical_utils/src/pond/query/reducer/entity_inflater.dart';
import 'package:jlogical_utils/src/pond/query/reducer/request/with_all_query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/all_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import 'abstract_file_query_request_reducer.dart';

class FileAllQueryRequestReducer<R extends Record>
    extends AbstractFileQueryRequestReducer<AllQueryRequest<R>, R, List<R>>
    with WithAllQueryRequestReducer<R, Iterable<State>> {
  @override
  final EntityInflater entityInflater;

  FileAllQueryRequestReducer({required this.entityInflater});

  @override
  FutureOr<List<State>> getStates(Iterable<State> accumulation) {
    return accumulation.toList();
  }
}
