import 'package:jlogical_utils/src/pond/property/context/property_context_provider.dart';
import 'package:jlogical_utils/src/pond/record/value_object_immutable_violation_error.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

abstract class Property<T> {
  final String name;

  late T _value;

  T get value => _value;

  set value(T value) {
    final canChange = _propertyContextProvider
            .mapIfNonNull((propertyContextProvider) => propertyContextProvider.create(this))
            .mapIfNonNull((propertyContext) => propertyContext.canChange) ??
        true;

    if (!canChange) {
      throw ImmutabilityViolationError();
    }

    _value = value;
  }

  PropertyContextProvider? _propertyContextProvider;
  void registerPropertyContextProvider(PropertyContextProvider propertyContextProvider){
    _propertyContextProvider = propertyContextProvider;
  }

  Property({required this.name, T? initialValue}) {
    if (initialValue != null) {
      _value = initialValue;
    }
  }

  TypeStateSerializer get typeStateSerializer;

  dynamic toStateValue() => value.mapIfNonNull((value) => typeStateSerializer.onSerialize(value));

  void fromStateValue(dynamic stateValue) => _value = typeStateSerializer.onDeserialize(stateValue);

  @override
  String toString() => 'Property<$T>{name = $name, value = $value}';
}
