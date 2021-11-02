import 'package:jlogical_utils/src/pond/property/property.dart';
import 'package:jlogical_utils/src/pond/property/with_stateful_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/utils/util.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

class ValueObjectProperty<V extends ValueObject> extends Property<V> {
  ValueObjectProperty({required String name, V? initialValue}) : super(name: name, initialValue: initialValue);

  @override
  TypeStateSerializer<ValueObject> get typeStateSerializer => ValueObjectTypeStateSerializer();
}

class ValueObjectTypeStateSerializer extends TypeStateSerializer<ValueObject> with WithStatefulTypeStateSerializer {
  @override
  ValueObject? onDeserialize(dynamic value) {
    return State.extractFrom(value).mapIfNonNull((state) => ValueObject.fromState(state));
  }
}
