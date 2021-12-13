import 'package:jlogical_utils/src/pond/property/field_property.dart';
import 'package:jlogical_utils/src/pond/property/validation/property_validator.dart';
import 'package:jlogical_utils/src/pond/property/with_stateful_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

class ValueObjectFieldProperty<V extends ValueObject> extends FieldProperty<V> {
  ValueObjectFieldProperty({
    required String name,
    V? initialValue,
    List<PropertyValidator<V>>? validators,
  }) : super(name: name, initialValue: initialValue, validators: validators);

  @override
  TypeStateSerializer<V> get typeStateSerializer => ValueObjectTypeStateSerializer<V>();
}

class ValueObjectTypeStateSerializer<V extends ValueObject> extends TypeStateSerializer<V>
    with WithStatefulTypeStateSerializer {
  @override
  V onDeserialize(dynamic value) {
    if (value == null) {
      throw ArgumentError.notNull('value');
    }

    final state = State.extractFrom(value);
    if (state == null) {
      throw FormatException('Cannot extract state from $value');
    }

    return ValueObject.fromState<V>(state);
  }
}
