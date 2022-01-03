import 'dart:convert';

import 'package:jlogical_utils/src/pond/state/persistence/state_persister.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

class JsonStatePersister extends StatePersister<String> {
  @override
  String persist(State state) {
    final jsonEncoder = JsonEncoder.withIndent('  ');
    return jsonEncoder.convert(state.fullValues);
  }

  @override
  State inflate(String persisted) {
    final valuesMap = json.decode(persisted);
    return State.extractFromOrNull(valuesMap) ?? (throw Exception('Could not inflate to state: [$persisted]'));
  }
}
