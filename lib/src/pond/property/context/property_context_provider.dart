import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/pond/property/context/property_context.dart';

abstract class PropertyContextProvider {
  PropertyContext createPropertyContext(Property property);
}