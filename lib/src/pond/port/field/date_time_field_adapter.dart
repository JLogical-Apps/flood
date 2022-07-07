import 'package:jlogical_utils/src/pond/property/field_property.dart';
import 'package:jlogical_utils/src/port/export_core.dart';

import 'abstract_field_adapter.dart';

class DateTimeFieldAdapter extends AbstractFieldAdapter<FieldProperty<DateTime>, DateTime> {
  @override
  PortField<DateTime?> toPortField(FieldProperty<DateTime> property) {
    return DatePortField(name: property.name, initialValue: property.getUnvalidated());
  }
}
