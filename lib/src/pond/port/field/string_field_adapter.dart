import 'package:jlogical_utils/src/pond/property/field_property.dart';
import 'package:jlogical_utils/src/port/export_core.dart';

import 'abstract_field_adapter.dart';

class StringFieldAdapter extends AbstractFieldAdapter {
  @override
  bool shouldWrap(FieldProperty value) {
    return value is FieldProperty<String>;
  }

  @override
  PortField toPortField(FieldProperty property) {
    return StringPortField(name: property.name, initialValue: property.getUnvalidated());
  }
}
