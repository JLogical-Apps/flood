import 'package:jlogical_utils/src/pond/property/context/property_context_provider.dart';
import 'package:jlogical_utils/src/pond/property/validation/property_validator.dart';
import 'package:jlogical_utils/src/pond/record/immutability_violation_error.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/validation/validation_exception.dart';
import 'package:jlogical_utils/src/pond/validation/validator.dart';
import '../state/state.dart';

abstract class Property<T> implements Validator {
  final String name;

  final List<PropertyValidator<T>> validators;

  T? _value;

  T? get value => _value;

  set value(T? value) {
    final canChange = _propertyContextProvider
            .mapIfNonNull((propertyContextProvider) => propertyContextProvider.createPropertyContext(this))
            .mapIfNonNull((propertyContext) => propertyContext.canChange) ??
        true;

    if (!canChange) {
      throw ImmutabilityViolationError();
    }

    _value = value;
  }

  Property({required this.name, List<PropertyValidator<T>>? validators, T? initialValue})
      : this.validators = validators ?? const [] {
    if (initialValue != null) {
      _value = initialValue;
    }
  }

  PropertyContextProvider? _propertyContextProvider;

  void registerPropertyContextProvider(PropertyContextProvider propertyContextProvider) {
    _propertyContextProvider = propertyContextProvider;
  }

  TypeStateSerializer get typeStateSerializer;

  dynamic toStateValue() => value.mapIfNonNull((value) => typeStateSerializer.onSerialize(value));

  void fromStateValue(dynamic stateValue) => _value = typeStateSerializer.onDeserialize(stateValue);

  void validate(State state) {
    return validators.forEach((propertyValidator) {
      try {
        propertyValidator.validateProperty(value);
      } on Exception catch (e) {
        throw ValidationException(failedValidator: this, errorMessage: e.toString());
      }
    });
  }

  @override
  String toString() => '$runtimeType{name = $name, value = $value}';
}
