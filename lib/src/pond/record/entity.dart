import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/pond/property/context/property_context.dart';
import 'package:jlogical_utils/src/pond/property/context/property_context_provider.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/pond/validation/with_validators.dart';

import 'has_id.dart';

abstract class Entity extends Record
    with WithValidators, WithIdPropertiesState
    implements HasId, PropertyContextProvider {
  String? id;

  Entity({this.id}) {
    properties.forEach((property) => property.registerPropertyContextProvider(this));
  }

  static E? fromState<E extends Entity>(State state) {
    return AppContext.global.constructEntity<E>()
      ..id = state.id
      ..state = state;
  }

  PropertyContext? create(Property property) {
    return PropertyContext(canChange: true);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Entity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
