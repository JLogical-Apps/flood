import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/state/persistence/modifiers/date_time_state_persister_modifier.dart';
import 'package:drop_core/src/state/persistence/modifiers/runtime_type_state_persister_modifier.dart';
import 'package:drop_core/src/state/persistence/modifiers/state_persister_modifier.dart';
import 'package:drop_core/src/state/persistence/modifiers/state_state_persister_modifier.dart';
import 'package:drop_core/src/state/persistence/state_persister.dart';
import 'package:drop_core/src/state/state.dart';

class StateStatePersister implements StatePersister<State> {
  final DropCoreContext context;

  final List<StatePersisterModifier> extraStatePersisterModifiers;

  StateStatePersister({required this.context, this.extraStatePersisterModifiers = const []});

  late List<StatePersisterModifier> statePersisterModifiers = [
    RuntimeTypeStatePersisterModifier(),
    StateStatePersisterModifier(context: context),
    DateTimeStatePersisterModifier(),
    ...extraStatePersisterModifiers
  ];

  @override
  State persist(State state) {
    final data = state.data;
    final modifiedData =
        statePersisterModifiers.fold<Map<String, dynamic>>(data, (data, modifier) => modifier.persist(data));

    return state.withData(modifiedData);
  }

  @override
  State inflate(State persisted) {
    final modifiedData =
        statePersisterModifiers.fold<Map<String, dynamic>>(persisted.data, (data, modifier) => modifier.inflate(data));

    return persisted.withData(modifiedData);
  }
}
