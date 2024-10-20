import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/state/persistence/modifiers/date_time_state_persister_modifier.dart';
import 'package:drop_core/src/state/persistence/modifiers/timestamp_state_persister_modifier.dart';
import 'package:drop_core/src/state/persistence/modifiers/runtime_type_state_persister_modifier.dart';
import 'package:drop_core/src/state/persistence/modifiers/state_persister_modifier.dart';
import 'package:drop_core/src/state/persistence/modifiers/state_state_persister_modifier.dart';
import 'package:drop_core/src/state/persistence/state_persister.dart';
import 'package:drop_core/src/state/state.dart';

class JsonStatePersister implements StatePersister<Map<String, dynamic>> {
  final DropCoreContext context;
  final List<StatePersisterModifier> extraStatePersisterModifiers;

  JsonStatePersister({required this.context, this.extraStatePersisterModifiers = const []});

  late List<StatePersisterModifier> statePersisterModifiers = [
    ...extraStatePersisterModifiers,
    RuntimeTypeStatePersisterModifier(),
    StateStatePersisterModifier(context: context),
    TimestampStatePersisterModifier(),
    DateTimeStatePersisterModifier(),
  ];

  @override
  Map<String, dynamic> persist(State state) {
    final data = state.fullData;
    final modifiedData =
        statePersisterModifiers.fold<Map<String, dynamic>>(data, (data, modifier) => modifier.persist(data));

    return modifiedData;
  }

  @override
  State inflate(Map<String, dynamic> persisted) {
    final modifiedData =
        statePersisterModifiers.fold<Map<String, dynamic>>(persisted, (data, modifier) => modifier.inflate(data));
    return State.fromMap(
      modifiedData,
      typeContext: context.typeContext,
    );
  }
}
