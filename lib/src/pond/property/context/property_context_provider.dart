import 'package:jlogical_utils/src/pond/property/context/property_context.dart';
import 'package:jlogical_utils/src/pond/property/property.dart';

abstract class PropertyContextProvider {
  PropertyContext createPropertyContext(Property property);
}
