import 'dart:convert';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/state/persistence/modifiers/date_time_state_persister_modifier.dart';
import 'package:drop_core/src/state/persistence/modifiers/runtime_type_state_persister_modifier.dart';
import 'package:drop_core/src/state/persistence/modifiers/state_persister_modifier.dart';
import 'package:drop_core/src/state/persistence/modifiers/state_state_persister_modifier.dart';
import 'package:drop_core/src/state/persistence/state_persister.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:type/type.dart';

class JsonStatePersister implements StatePersister<String> {
  final DropCoreContext context;

  JsonStatePersister({required this.context});

  late List<StatePersisterModifier> statePersisterModifiers = [
    RuntimeTypeStatePersisterModifier(),
    StateStatePersisterModifier(context: context),
    DateTimeStatePersisterModifier(),
  ];

  @override
  String persist(State state) {
    final data = state.fullData;
    final modifiedData =
        statePersisterModifiers.fold<Map<String, dynamic>>(data, (data, modifier) => modifier.persist(data));

    final jsonEncoder = JsonEncoder.withIndent('  ');
    return jsonEncoder.convert(modifiedData);
  }

  @override
  State inflate(String persisted) {
    final persistedData = json.decode(persisted) as Map<String, dynamic>;
    final modifiedData =
        statePersisterModifiers.fold<Map<String, dynamic>>(persistedData, (data, modifier) => modifier.inflate(data));
    return State.fromMap(
      modifiedData,
      runtimeTypeGetter: (name) => context.typeContext.getByName(name),
    );
  }
}
