import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/property/modifier/context/property_modifier_context.dart';

import 'context/property_modifier_context_provider.dart';

abstract class PropertyModifier<T> {
  late PropertyModifierContextProvider propertyModifierContextProvider;

  late PropertyModifierContext context = propertyModifierContextProvider.createPropertyModifierContext();

  Validator? get validator => null;

  T Function(T propertyValue)? get getTransformer => null;

  void Function(T propertyValue)? get setTransformer => null;
}
