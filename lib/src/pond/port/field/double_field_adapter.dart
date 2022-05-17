import 'package:jlogical_utils/src/pond/property/field_property.dart';
import 'package:jlogical_utils/src/port/export_core.dart';

import 'abstract_field_adapter.dart';

class DoubleFieldAdapter extends AbstractFieldAdapter<FieldProperty<double>, double?> {
  @override
  PortField<double?> toPortField(FieldProperty<double> property) {
    return DoublePortField(name: property.name, initialValue: property.getUnvalidated());
  }
}
