import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:utils_core/utils_core.dart';

class IsPhoneValueObjectProperty<G extends String?, S extends String?, L>
    with IsValueObjectPropertyWrapper<G, S, L, IsPhoneValueObjectProperty<G, S, L>> {
  final ValueObjectProperty<G, S, L, dynamic> _property;

  @override
  ValueObjectProperty<G, S, L, dynamic> get property => (_property as ValueObjectProperty<G, S, L, ValueObjectProperty>).withValidator(Validator.isPhone().cast<G>());

  IsPhoneValueObjectProperty({required ValueObjectProperty<G, S, L, ValueObjectProperty> property})
      : _property = property;

  @override
  IsPhoneValueObjectProperty<G, S, L> copy() {
    return IsPhoneValueObjectProperty<G, S, L>(property: _property.copy());
  }
}
