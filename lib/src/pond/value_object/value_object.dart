import 'package:jlogical_utils/src/pond/export.dart';

class ValueObject with WithPropertiesState implements Stateful {
  State get state => generatePropertiesState();

  static V? fromState<V extends ValueObject>(State state) {
    return AppContext.global.constructValueObject<V>()?..inflateProperties(state);
  }
}
