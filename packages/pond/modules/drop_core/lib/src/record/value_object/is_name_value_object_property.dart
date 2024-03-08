import 'package:drop_core/src/record/value_object/value_object_property.dart';

class IsNameValueObjectProperty<G extends String?, S extends String?, L>
    with IsValueObjectPropertyWrapper<G, S, L, IsNameValueObjectProperty<G, S, L>> {
  final ValueObjectProperty<G, S, L, dynamic> _property;

  @override
  ValueObjectProperty<G, S, L, dynamic> get property =>
      (_property as ValueObjectProperty<G, S, L, ValueObjectProperty>);

  IsNameValueObjectProperty({required ValueObjectProperty<G, S, L, ValueObjectProperty> property})
      : _property = property;

  @override
  IsNameValueObjectProperty<G, S, L> copy() {
    return IsNameValueObjectProperty<G, S, L>(property: _property.copy());
  }
}
