import 'package:equatable/equatable.dart';
import 'package:jlogical_utils/src/pond/property/context/property_context_provider.dart';
import 'package:jlogical_utils/src/pond/property/modifier/context/property_modifier_context_provider.dart';
import 'package:jlogical_utils/src/pond/record/immutability_violation_error.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/validation/validator.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import 'modifier/context/property_modifier_context.dart';

abstract class Property<T> with EquatableMixin implements PropertyModifierContextProvider<T>, Validator {
  final String name;

  T? getUnvalidated();

  void setUnvalidated(T value);

  Property({required this.name, T? initialValue}) {
    if (initialValue != null) {
      setUnvalidated(initialValue);
    }
  }

  T get value {
    validate();
    return getUnvalidated() as T;
  }

  set value(T value) {
    final canChange = _propertyContextProvider
            .mapIfNonNull((propertyContextProvider) => propertyContextProvider.createPropertyContext(this))
            .mapIfNonNull((propertyContext) => propertyContext.canChange) ??
        true;

    if (!canChange) {
      throw ImmutabilityViolationError();
    }

    setUnvalidated(value);

    validate();
  }

  PropertyContextProvider? _propertyContextProvider;

  void registerPropertyContextProvider(PropertyContextProvider propertyContextProvider) {
    _propertyContextProvider = propertyContextProvider;
  }

  TypeStateSerializer get typeStateSerializer;

  dynamic toStateValue() => getUnvalidated().mapIfNonNull((value) => typeStateSerializer.serialize(value));

  void fromStateValue(dynamic stateValue) => setUnvalidated(typeStateSerializer.deserialize(stateValue));

  PropertyModifierContext<T> createPropertyModifierContext() {
    return PropertyModifierContext(property: this);
  }

  @override
  String toString() => '$runtimeType{name = $name, value = ${getUnvalidated()}';

  @override
  List<Object?> get props => [name, value];
}
