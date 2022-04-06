import 'package:jlogical_utils/src/pond/schema/field/schema_field.dart';

class RequiredSchemaField extends SchemaField {
  final SchemaField parent;

  RequiredSchemaField({required this.parent});

  @override
  bool matches(bool exists, dynamic value) {
    return parent.matches(exists, value) && exists && value != null;
  }
}
