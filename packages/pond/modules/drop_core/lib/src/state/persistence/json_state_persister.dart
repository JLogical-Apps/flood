import 'dart:convert';

import 'package:drop_core/src/state/persistence/json/date_time_json_state_persister_modifier.dart';
import 'package:drop_core/src/state/persistence/json/json_state_persister_modifier.dart';
import 'package:drop_core/src/state/persistence/json/runtime_type_json_state_persister_modifier.dart';
import 'package:drop_core/src/state/persistence/json/state_json_state_persister_modifier.dart';
import 'package:drop_core/src/state/persistence/state_persister.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:type/type.dart';

class JsonStatePersister implements StatePersister<String> {
  final RuntimeType Function(String typeName) runtimeTypeGetter;

  JsonStatePersister({required this.runtimeTypeGetter});

  late List<JsonStatePersisterModifier> jsonStatePersisterModifiers = [
    StateJsonStatePersisterModifier(runtimeTypeGetter: runtimeTypeGetter),
    DateTimeJsonStatePersisterModifier(),
    RuntimeTypeJsonStatePersisterModifier(),
  ];

  @override
  String persist(State state) {
    final data = state.fullData;
    final modifiedData =
        jsonStatePersisterModifiers.fold<Map<String, dynamic>>(data, (data, modifier) => modifier.persist(data));

    final jsonEncoder = JsonEncoder.withIndent('  ');
    return jsonEncoder.convert(modifiedData);
  }

  @override
  State inflate(String persisted) {
    final persistedData = json.decode(persisted) as Map<String, dynamic>;
    final modifiedData = jsonStatePersisterModifiers.fold<Map<String, dynamic>>(
        persistedData, (data, modifier) => modifier.inflate(data));
    return State.fromMap(modifiedData, runtimeTypeGetter: runtimeTypeGetter);
  }
}
