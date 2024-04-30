import 'package:drop_core/src/record/value_object/value_object_property.dart';

class DefaultValueObjectProperty<T, S> with IsValueObjectPropertyWrapper<T, S, DefaultValueObjectProperty<T, S>> {
  @override
  final ValueObjectProperty<T, S, dynamic> property;

  final T Function() defaultValueGetter;

  DefaultValueObjectProperty({required this.property, required this.defaultValueGetter});

  T getDefaultValue() {
    return defaultValueGetter();
  }

  @override
  DefaultValueObjectProperty<T, S> copy() {
    return DefaultValueObjectProperty<T, S>(property: property.copy(), defaultValueGetter: defaultValueGetter);
  }
}
