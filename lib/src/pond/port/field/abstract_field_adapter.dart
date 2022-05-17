import 'package:jlogical_utils/src/patterns/export_core.dart';
import 'package:jlogical_utils/src/port/export_core.dart';

import '../../property/field_property.dart';

abstract class AbstractFieldAdapter<P extends FieldProperty<V>, V> extends Wrapper<FieldProperty>
    with WithSubtypeWrapper<P, FieldProperty> {
  PortField<V?> toPortField(P property);
}
