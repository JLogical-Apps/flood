import 'package:jlogical_utils/src/patterns/export_core.dart';
import 'package:jlogical_utils/src/port/export_core.dart';

import '../../property/field_property.dart';

abstract class AbstractFieldAdapter extends Wrapper<FieldProperty> {
  PortField toPortField(FieldProperty property);
}
