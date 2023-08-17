import 'dart:convert';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/state/persistence/state_persister.dart';

class JsonStringStatePersister with IsStatePersisterWrapper<String> {
  final DropCoreContext context;

  JsonStringStatePersister({required this.context});

  @override
  StatePersister<String> get statePersister => StatePersister.json(context: context).map(
        persistMapper: (data) {
          final jsonEncoder = JsonEncoder.withIndent('  ');
          return jsonEncoder.convert(data);
        },
        inflateMapper: (inflated) {
          return json.decode(inflated) as Map<String, dynamic>;
        },
      );
}
