import 'dart:convert';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/state/persistence/modifiers/state_persister_modifier.dart';
import 'package:drop_core/src/state/persistence/state_persister.dart';

class JsonStringStatePersister with IsStatePersisterWrapper<String> {
  final DropCoreContext context;
  final List<StatePersisterModifier> extraStatePersisterModifiers;

  JsonStringStatePersister({required this.context, this.extraStatePersisterModifiers = const []});

  @override
  StatePersister<String> get statePersister => StatePersister.json(
        context: context,
        extraStatePersisterModifiers: extraStatePersisterModifiers,
      ).map(
        persistMapper: (data) {
          final jsonEncoder = JsonEncoder.withIndent('  ');
          return jsonEncoder.convert(data);
        },
        inflateMapper: (inflated) {
          return json.decode(inflated) as Map<String, dynamic>;
        },
      );
}
