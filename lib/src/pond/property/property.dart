import 'package:equatable/equatable.dart';
import 'package:jlogical_utils/src/pond/property/context/property_context_provider.dart';
import 'package:jlogical_utils/src/pond/property/required_property.dart';
import 'package:jlogical_utils/src/pond/record/immutability_violation_error.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/validation/validator.dart';
import 'package:jlogical_utils/src/utils/util.dart';

import 'fallback_property.dart';

abstract class Property<T> with EquatableMixin implements Validator {
  final String name;

  T? getUnvalidated();

  void setUnvalidated(T value);

  void validate() {}

  Property({required this.name, T? initialValue}) {
    if (initialValue != null) {
      setUnvalidated(value);
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

  dynamic toStateValue() => value.mapIfNonNull((value) => typeStateSerializer.onSerialize(value));

  void fromStateValue(dynamic stateValue) => setUnvalidated(typeStateSerializer.onDeserialize(stateValue));

  @override
  String toString() => '$runtimeType{name = $name, value = $value}';

  @override
  List<Object?> get props => [name, value];
}

extension PropertyExtensions<T> on Property<T?> {
  RequiredProperty<T> required() {
    return RequiredProperty(parent: this);
  }

  FallbackProperty<T?> withFallback(T? fallback()) {
    return FallbackProperty(parent: this, fallback: fallback);
  }
}