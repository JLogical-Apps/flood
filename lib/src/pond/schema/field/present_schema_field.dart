import 'schema_field.dart';

class PresentSchemaField extends SchemaField {
  final SchemaField parent;

  PresentSchemaField({required this.parent});

  @override
  bool matches(bool exists, dynamic value) {
    return parent.matches(exists, value) && exists;
  }
}
