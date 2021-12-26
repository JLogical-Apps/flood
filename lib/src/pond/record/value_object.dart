import 'package:equatable/equatable.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/property/context/property_context.dart';
import 'package:jlogical_utils/src/pond/property/context/property_context_provider.dart';
import 'package:jlogical_utils/src/pond/property/property.dart';
import 'package:jlogical_utils/src/pond/property/with_properties_state.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/pond/utils/resolvable.dart';
import 'package:jlogical_utils/src/pond/validation/validation_state.dart';

abstract class ValueObject extends Record
    with EquatableMixin, WithPropertiesState
    implements PropertyContextProvider, Resolvable {
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
  List<Object?> get props => properties;
}
