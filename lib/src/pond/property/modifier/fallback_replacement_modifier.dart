import 'package:jlogical_utils/src/pond/property/modifier/property_modifier.dart';

class FallbackReplacementPropertyModifier<T> extends PropertyModifier<T> {
  final T Function() fallbackGetter;

  FallbackReplacementPropertyModifier(this.fallbackGetter);

  T Function(T propertyValue)? get getTransformer => (value) {
        if (value == null) {
          value = fallbackGetter();
          if (value != null) {
            property.value = value;
          }
        }
        return value;
      };
}
