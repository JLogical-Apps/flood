import 'package:jlogical_utils/src/port/export_core.dart';

import '../property/with_properties_state.dart';

mixin WithPortGenerator<V> implements WithPropertiesState {
  List<PortField> get portFields;

  Port<V> toPort() {
    return Port<V>(fields: portFields).withSubmitMapper((resultValueByName) {
      var stateValues = state.values;
      resultValueByName.forEach((name, value) {
        stateValues[name] = value;
      });
      state = state.copyWith(values: stateValues);

      return this as V;
    });
  }
}
