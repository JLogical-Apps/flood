import 'package:jlogical_utils/src/pond/property/field_property.dart';
import 'package:jlogical_utils/src/port/export_core.dart';

import 'abstract_field_adapter.dart';

class IntFieldAdapter extends AbstractFieldAdapter<FieldProperty<int>, int?> {
  @override
  PortField<int?> toPortField(FieldProperty<int> property) {
    return IntPortField(name: property.name, initialValue: property.getUnvalidated());
  }
}
