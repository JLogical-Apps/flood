import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/property/unvalidated_property.dart';

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
