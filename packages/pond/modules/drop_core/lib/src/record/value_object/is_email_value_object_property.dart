import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:utils_core/utils_core.dart';

class IsEmailValueObjectProperty<G extends String?, S extends String?>
    with IsValueObjectPropertyWrapper<G, S, IsEmailValueObjectProperty<G, S>> {
  final ValueObjectProperty<G, S, dynamic> _property;

  @override
  ValueObjectProperty<G, S, dynamic> get property =>
      (_property as ValueObjectProperty<G, S, ValueObjectProperty>).withValidator(Validator.isEmail().cast<G>());

  IsEmailValueObjectProperty({required ValueObjectProperty<G, S, ValueObjectProperty> property}) : _property = property;

  @override
  IsEmailValueObjectProperty<G, S> copy() {
    return IsEmailValueObjectProperty<G, S>(property: _property.copy());
  }
}
