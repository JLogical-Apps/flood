import 'dart:convert';

import 'package:drop_core/src/state/persistence/state_persister.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class JsonStatePersister extends StatePersister<String> {
  @override
  String persist(State state) {
    final fullData = state.fullData;
    fullData.replaceWhere((key, value) => value is State, (key, value) => (value as State).fullData);

    final jsonEncoder = JsonEncoder.withIndent('  ');
    return jsonEncoder.convert(fullData);
  }

  @override
  State inflate(String persisted) {
    final fullData = json.decode(persisted) as Map<String, dynamic>;
    return State.fromMap(fullData);
  }
}
