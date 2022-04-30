import 'package:jlogical_utils/src/pond/schema/field/schema_field.dart';

class ListSchemaField extends SchemaField {
  final SchemaField itemSchemaField;

  ListSchemaField({required this.itemSchemaField});

  @override
  bool matches(bool exists, value) {
    if (value == null) {
      return true;
    }

    if (value is! List) {
      return false;
    }

    return value.every((item) => itemSchemaField.matches(true, item));
  }
}
