import 'package:drop_core/src/record/value_object/value_object_property.dart';

class RequiredOnEditValueObjectProperty<T, S, L>
    with IsValueObjectPropertyWrapper<T, S, L, RequiredOnEditValueObjectProperty<T, S, L>> {
  @override
  final ValueObjectProperty<T, S, L, dynamic> property;

  final bool requiredOnEdit;

  RequiredOnEditValueObjectProperty({required this.property, this.requiredOnEdit = true});

  @override
  RequiredOnEditValueObjectProperty<T, S, L> copy() {
    return RequiredOnEditValueObjectProperty<T, S, L>(
      property: property.copy(),
      requiredOnEdit: requiredOnEdit,
    );
  }
}
