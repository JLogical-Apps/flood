import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:utils_core/utils_core.dart';

class IsPhoneValueObjectProperty<G extends String?, S extends String?>
    with IsValueObjectPropertyWrapper<G, S, IsPhoneValueObjectProperty<G, S>> {
  final ValueObjectProperty<G, S, dynamic> _property;

  @override
  ValueObjectProperty<G, S, dynamic> get property =>
      (_property as ValueObjectProperty<G, S, ValueObjectProperty>).withValidator(Validator.isPhone().cast<G>());

  IsPhoneValueObjectProperty({required ValueObjectProperty<G, S, ValueObjectProperty> property}) : _property = property;

  @override
  IsPhoneValueObjectProperty<G, S> copy() {
    return IsPhoneValueObjectProperty<G, S>(property: _property.copy());
  }
}
