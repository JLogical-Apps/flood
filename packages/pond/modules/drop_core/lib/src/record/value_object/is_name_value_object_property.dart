import 'package:drop_core/src/record/value_object/value_object_property.dart';

class IsNameValueObjectProperty<G extends String?, S extends String?>
    with IsValueObjectPropertyWrapper<G, S, IsNameValueObjectProperty<G, S>> {
  final ValueObjectProperty<G, S, dynamic> _property;

  @override
  ValueObjectProperty<G, S, dynamic> get property => (_property as ValueObjectProperty<G, S, ValueObjectProperty>);

  IsNameValueObjectProperty({required ValueObjectProperty<G, S, ValueObjectProperty> property}) : _property = property;

  @override
  IsNameValueObjectProperty<G, S> copy() {
    return IsNameValueObjectProperty<G, S>(property: _property.copy());
  }
}
