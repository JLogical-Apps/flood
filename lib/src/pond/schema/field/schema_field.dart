import 'dart:core' as core;

import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/schema/field/embedded_schema_field.dart';
import 'package:jlogical_utils/src/pond/schema/field/int_schema_field.dart';
import 'package:jlogical_utils/src/pond/schema/field/list_schema_field.dart';
import 'package:jlogical_utils/src/pond/schema/field/present_schema_field.dart';
import 'package:jlogical_utils/src/pond/schema/field/required_schema_field.dart';
import 'package:jlogical_utils/src/pond/schema/field/string_schema_field.dart';

import 'bool_schema_field.dart';

abstract class SchemaField {
  /// Returns whether [value] matches in the schema.
  /// If [exists] but [value] is null, then the value is in the State, just set to null.
  /// If [exists] is false and [value] is null, then the value was not even in the State.
  core.bool matches(core.bool exists, core.dynamic value);

  static SchemaField get int {
    return IntSchemaField();
  }

  static SchemaField get string {
    return StringSchemaField();
  }

  static SchemaField get bool {
    return BoolSchemaField();
  }

  static SchemaField embedded<V extends ValueObject>() {
    return EmbeddedSchemaField<V>();
  }

  static SchemaField list(SchemaField itemSchemaField) {
    return ListSchemaField(itemSchemaField: itemSchemaField);
  }

  SchemaField get required {
    return RequiredSchemaField(parent: this);
  }

  SchemaField get present {
    return PresentSchemaField(parent: this);
  }
}
