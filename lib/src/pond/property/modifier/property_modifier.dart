import 'package:jlogical_utils/src/pond/property/modifier/context/property_modifier_context.dart';

import '../../validation/validator.dart';
import '../property.dart';
import 'context/property_modifier_context_provider.dart';

abstract class PropertyModifier<T> {
  late PropertyModifierContextProvider<T> propertyModifierContextProvider;

  late PropertyModifierContext<T> context = propertyModifierContextProvider.createPropertyModifierContext();

  Property<T> get property => context.property;

  Validator? get validator => null;

  T Function(T propertyValue)? get getTransformer => null;

  void Function(T propertyValue)? get setTransformer => null;
}
