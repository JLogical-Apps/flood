import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

abstract class ValueObject extends Record {
  static V? fromState<V extends ValueObject>(State state) {
    return AppContext.global.constructValueObject<V>()..state = state;
  }
}
