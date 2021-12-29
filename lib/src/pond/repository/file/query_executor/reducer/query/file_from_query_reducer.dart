import 'dart:io';

import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_from_query_reducer.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/utils/file_extensions.dart';
import 'package:path/path.dart';

class FileFromQueryReducer extends AbstractFromQueryReducer<Iterable<Record>> {
  final Directory baseDirectory;

  final Future<State> Function(String id) stateGetter;

  const FileFromQueryReducer({required this.baseDirectory, required this.stateGetter});

  @override
  Future<Iterable<Record>> reduce({required Iterable<Record>? accumulation, required Query query}) async {
    final descendants = AppContext.global.getDescendants(query.recordType);
    final types = {...descendants, query.recordType};
    final typeNames = types.map((type) => type.toString()).toList();

    final _baseDirectory = await baseDirectory.ensureCreated();
    final states = await Future.wait(_baseDirectory
        .listSync()
        .where((file) => file is File)
        .map((file) => file as File)
        .map((file) => basenameWithoutExtension(file.path))
        .map((id) => stateGetter(id)));

    return states.where((state) => typeNames.contains(state.type)).map((state) => Entity.fromState(state));
  }
}
