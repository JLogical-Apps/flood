import 'dart:io';

import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/query/from_query.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_query_reducer.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:path/path.dart';

import '../../../../../record/entity.dart';

class FileFromQueryReducer extends AbstractQueryReducer<FromQuery, Iterable<State>> {
  final Directory baseDirectory;

  final Future<State> Function(String id) stateGetter;

  const FileFromQueryReducer({required this.baseDirectory, required this.stateGetter});

  @override
  Future<Iterable<State>> reduce({required Iterable<State>? accumulation, required Query query}) async {
    final _baseDirectory = await baseDirectory.ensureCreated();
    Iterable<State> states = await Future.wait(_baseDirectory
        .listSync()
        .where((file) => file is File)
        .map((file) => file as File)
        .where((file) => extension(file.path) == '.entity')
        .map((file) => basenameWithoutExtension(file.path))
        .map((id) => stateGetter(id)));

    final shouldNarrowByType = query.recordType != Entity;
    if (shouldNarrowByType) {
      final descendants = AppContext.global.getDescendants(query.recordType);
      final types = {...descendants, query.recordType};
      final typeNames = types.map((type) => type.toString()).toList();

      states = states.where((state) => typeNames.contains(state.type));
    }

    return states;
  }
}
