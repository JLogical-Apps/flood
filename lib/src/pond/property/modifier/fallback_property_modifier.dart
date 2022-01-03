import 'package:jlogical_utils/src/pond/property/modifier/property_modifier.dart';

class FallbackPropertyModifier<T> extends PropertyModifier<T> {
  final T Function() fallbackGetter;

  FallbackPropertyModifier(this.fallbackGetter);

  T Function(T propertyValue)? get getTransformer => (value) {
        if (value == null) {
          return fallbackGetter();
        }

        return value;
      };
}
