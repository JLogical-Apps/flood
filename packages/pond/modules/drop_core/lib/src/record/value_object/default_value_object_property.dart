import 'package:drop_core/src/record/value_object/value_object_property.dart';

class DefaultValueObjectProperty<T, S, L>
    with IsValueObjectPropertyWrapper<T, S, L, DefaultValueObjectProperty<T, S, L>> {
  @override
  final ValueObjectProperty<T, S, L, dynamic> property;

  final T Function() defaultValueGetter;

  DefaultValueObjectProperty({required this.property, required this.defaultValueGetter});

  T getDefaultValue() {
    return defaultValueGetter();
  }

  @override
  DefaultValueObjectProperty<T, S, L> copy() {
    return DefaultValueObjectProperty<T, S, L>(property: property.copy(), defaultValueGetter: defaultValueGetter);
  }

  @override
  List<Object?> get props => [property];
}
