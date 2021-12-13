import 'package:equatable/equatable.dart';
import 'package:jlogical_utils/src/pond/property/context/property_context_provider.dart';
import 'package:jlogical_utils/src/pond/property/validation/property_validator.dart';
import 'package:jlogical_utils/src/pond/record/immutability_violation_error.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/validation/validation_exception.dart';
import 'package:jlogical_utils/src/pond/validation/validator.dart';
import 'package:jlogical_utils/src/utils/util.dart';

abstract class Property<T> with EquatableMixin implements Validator {
  final String name;

  final List<PropertyValidator<T>> validators;

  T getUnvalidated();

  void setUnvalidated(T value);

  Property({required this.name, List<PropertyValidator<T>>? validators, T? initialValue})
      : this.validators = validators ?? const [] {
    if (initialValue != null) {
      setUnvalidated(value);
    }
  }

  T get value {
    validate();
    return getUnvalidated();
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

  void validate() {
    return validators.forEach((propertyValidator) {
      try {
        propertyValidator.validateProperty(getUnvalidated());
      } on Exception catch (e) {
        throw ValidationException(failedValidator: this, errorMessage: e.toString());
      }
    });
  }

  @override
  String toString() => '$runtimeType{name = $name, value = $value}';

  @override
  List<Object?> get props => [name, value];
}
