import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/property/unvalidated_property.dart';

import '../../context/app_context.dart';
import '../../property/field_property.dart';
import '../../property/property.dart';
import '../../record/value_object.dart';

abstract class Draft<V extends ValueObject> extends ValueObject {
  static const sourceIdField = 'sourceId';

  late final sourceIdProperty = FieldProperty<String>(name: sourceIdField);

  late V sourcePrototype = AppContext.global.constructValueObject<V>();

  @override
  List<Property> get properties =>
      super.properties +
      [
        sourceIdProperty,
        ...sourcePrototype.properties.map((property) => UnvalidatedProperty(parentProperty: property)),
      ];
}
