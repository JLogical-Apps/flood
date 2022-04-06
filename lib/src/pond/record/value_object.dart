import 'package:equatable/equatable.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/property/context/property_context.dart';
import 'package:jlogical_utils/src/pond/property/context/property_context_provider.dart';
import 'package:jlogical_utils/src/pond/property/field_property.dart';
import 'package:jlogical_utils/src/pond/property/property.dart';
import 'package:jlogical_utils/src/pond/property/with_properties_state.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/pond/utils/resolvable.dart';
import 'package:jlogical_utils/src/pond/validation/validation_state.dart';
import 'package:meta/meta.dart';

abstract class ValueObject extends Record
    with EquatableMixin, WithPropertiesState
    implements PropertyContextProvider, Resolvable {
  static const timeCreatedField = 'timeCreated';
  late final timeCreatedProperty =
      FieldProperty<DateTime>(name: timeCreatedField).withFallbackReplacement(() => AppContext.global.getNow());

  ValueObject() {
    properties.forEach((property) => property.registerPropertyContextProvider(this));
  }

  DateTime get timeCreated => timeCreatedProperty.value!;

  @mustCallSuper
  List<Property> get properties => [timeCreatedProperty];

  static V fromState<V extends ValueObject>(State state) {
    return AppContext.global.constructValueObject<V>()..state = state;
  }

  static V? fromStateOrNull<V extends ValueObject>(State state) {
    return AppContext.global.constructValueObjectOrNull<V>()?..state = state;
  }

  PropertyContext createPropertyContext(Property property) {
    return PropertyContext(
      canChange: validationState == ValidationState.unvalidated,
    );
  }

  @override
  List<Object?> get props => [state];
}
