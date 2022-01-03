import 'property_modifier_context.dart';

abstract class PropertyModifierContextProvider<T> {
  PropertyModifierContext<T> createPropertyModifierContext();
}