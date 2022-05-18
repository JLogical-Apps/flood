import 'package:jlogical_utils/src/pond/property/modifier/fallback_replacement_modifier.dart';
import 'package:jlogical_utils/src/pond/property/modifier/required_property_modifier.dart';
import 'package:jlogical_utils/src/pond/property/property.dart';
import 'package:jlogical_utils/src/pond/property/with_global_type_serializer.dart';

import '../../patterns/export_core.dart';
import 'modifier/fallback_property_modifier.dart';
import 'modifier/property_modifier.dart';

class FieldProperty<T> extends Property<T?> with WithGlobalTypeSerializer {
  final List<SyncValidator> validators;
  final List<PropertyModifier<T?>> modifiers;

  T? _value;

  FieldProperty({
    required String name,
    T? initialValue,
    this.validators: const [],
    List<PropertyModifier<T>>? modifiers,
  })  : this.modifiers = modifiers ?? [],
        super(name: name, initialValue: initialValue);

  @override
  T? getUnvalidated() {
    return modifiers.fold(_value, (value, modifier) {
      modifier.propertyModifierContextProvider = this;
      final getTransformer = modifier.getTransformer;
      if (getTransformer == null) {
        return value;
      }

      return getTransformer(value);
    });
  }

  @override
  void setUnvalidated(T? value) {
    _value = value;
    modifiers.forEach((modifier) {
      modifier.propertyModifierContextProvider = this;
      modifier.setTransformer?.call(value);
    });
  }

  @override
  void onValidateSync(_) {
    modifiers.forEach((modifier) {
      modifier.propertyModifierContextProvider = this;
      modifier.validator?.validateSync(null);
    });
    validators.forEach((validator) => validator.validateSync(null));

    if (_value is SyncValidator) {
      (_value as SyncValidator).validateSync(null);
    }
  }

  FieldProperty<T> required() {
    modifiers.add(RequiredPropertyModifier());
    return this;
  }

  FieldProperty<T> withFallback(T? fallback()) {
    modifiers.add(FallbackPropertyModifier(fallback));
    return this;
  }

  FieldProperty<T> withFallbackReplacement(T? fallback()) {
    modifiers.add(FallbackReplacementPropertyModifier(fallback));
    return this;
  }
}
