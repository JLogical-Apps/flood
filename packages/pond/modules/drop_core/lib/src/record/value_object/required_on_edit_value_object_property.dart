import 'package:drop_core/src/record/value_object/value_object_property.dart';

class RequiredOnEditValueObjectProperty<T, S>
    with IsValueObjectPropertyWrapper<T, S, RequiredOnEditValueObjectProperty<T, S>> {
  @override
  final ValueObjectProperty<T, S, dynamic> property;

  final bool requiredOnEdit;

  RequiredOnEditValueObjectProperty({required this.property, this.requiredOnEdit = true});

  @override
  RequiredOnEditValueObjectProperty<T, S> copy() {
    return RequiredOnEditValueObjectProperty<T, S>(
      property: property.copy(),
      requiredOnEdit: requiredOnEdit,
    );
  }
}
