import 'package:jlogical_utils/src/pond/context/resolvable.dart';
import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/pond/property/context/property_context.dart';
import 'package:jlogical_utils/src/pond/property/context/property_context_provider.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/validation/validation_state.dart';
import 'package:jlogical_utils/src/pond/validation/with_validators.dart';

abstract class ValueObject extends Record with WithValidators, WithPropertiesState implements PropertyContextProvider, Resolvable {
  ValueObject() {
    properties.forEach((property) => property.registerPropertyContextProvider(this));
  }

  static V fromState<V extends ValueObject>(State state) {
    return AppContext.global.constructValueObject<V>()..state = state;
  }

  PropertyContext createPropertyContext(Property property) {
    return PropertyContext(
      canChange: validationState == ValidationState.unvalidated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ValueObject && runtimeType == other.runtimeType && state == other.state;

  @override
  int get hashCode => state.hashCode;
}
