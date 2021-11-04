import 'package:jlogical_utils/src/pond/property/property.dart';
import 'package:jlogical_utils/src/pond/property/validation/property_validator.dart';
import 'package:jlogical_utils/src/pond/property/with_stateful_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/utils/util.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

class ValueObjectProperty<V extends ValueObject> extends Property<V> {
  ValueObjectProperty({
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
  V? onDeserialize(dynamic value) {
    return State.extractFrom(value).mapIfNonNull((state) => ValueObject.fromState<V>(state));
  }
}
