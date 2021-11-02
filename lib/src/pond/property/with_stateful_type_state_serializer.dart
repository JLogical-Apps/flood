import 'package:jlogical_utils/src/pond/state/stateful.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

mixin WithStatefulTypeStateSerializer<T extends Stateful> on TypeStateSerializer<T> {
  @override
  dynamic onSerialize(T value) {
    return value.state.values;
  }
}
