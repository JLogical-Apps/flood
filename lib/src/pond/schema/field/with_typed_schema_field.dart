import 'package:jlogical_utils/src/pond/schema/field/schema_field.dart';

mixin WithTypedSchemaField<T> on SchemaField {
  @override
  bool matches(bool exists, dynamic value) {
    return value is T?;
  }
}
