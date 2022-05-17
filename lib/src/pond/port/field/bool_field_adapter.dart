import 'package:jlogical_utils/src/pond/property/field_property.dart';
import 'package:jlogical_utils/src/port/export_core.dart';

import 'abstract_field_adapter.dart';

class BoolFieldAdapter extends AbstractFieldAdapter<FieldProperty<bool>, bool> {
  @override
  PortField<bool> toPortField(FieldProperty<bool> property) {
    return BoolPortField(name: property.name, initialValue: property.getUnvalidated());
  }
}
