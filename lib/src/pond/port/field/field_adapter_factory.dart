import 'package:jlogical_utils/src/patterns/export_core.dart';
import 'package:jlogical_utils/src/pond/port/field/abstract_field_adapter.dart';
import 'package:jlogical_utils/src/pond/port/field/asset_field_adapter.dart';
import 'package:jlogical_utils/src/pond/port/field/bool_field_adapter.dart';
import 'package:jlogical_utils/src/pond/port/field/double_field_adapter.dart';
import 'package:jlogical_utils/src/pond/port/field/int_field_adapter.dart';
import 'package:jlogical_utils/src/pond/port/field/string_field_adapter.dart';
import 'package:jlogical_utils/src/pond/property/field_property.dart';

class FieldAdapterFactory {
  Resolver<FieldProperty, AbstractFieldAdapter> resolver = WrapperResolver([
    AssetFieldAdapter(),
    StringFieldAdapter(),
    IntFieldAdapter(),
    DoubleFieldAdapter(),
    BoolFieldAdapter(),
  ]);

  AbstractFieldAdapter? resolveOrNull(FieldProperty property) {
    return resolver.resolveOrNull(property);
  }
}
