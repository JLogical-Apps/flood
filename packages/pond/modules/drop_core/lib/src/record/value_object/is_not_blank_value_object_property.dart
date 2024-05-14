import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:utils_core/utils_core.dart';

class IsNotBlankValueObjectProperty with IsValueObjectPropertyWrapper<String, String, IsNotBlankValueObjectProperty> {
  @override
  final ValueObjectProperty<String, String, dynamic> property;

  IsNotBlankValueObjectProperty({required this.property});

  IsNotBlankValueObjectProperty.fromProperty({
    required ValueObjectProperty<String?, String?, ValueObjectProperty> property,
  }) : property = property.withValidator(Validator.isNotBlank()).withMapper(
              getMapper: (value) {
                if (value == null || value.isBlank) {
                  throw Exception('Cannot be blank! [$property]');
                }

                return value;
              },
              setMapper: (value) => value.nullIfBlank ?? (throw Exception('Cannot be blank! [$property]')),
            );

  @override
  Type get getterType => String;

  @override
  Type get setterType => String;

  @override
  IsNotBlankValueObjectProperty copy() {
    return IsNotBlankValueObjectProperty(property: property.copy());
  }
}
