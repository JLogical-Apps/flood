import 'package:jlogical_utils/src/pond/port/field/field_adapter_factory.dart';
import 'package:jlogical_utils/src/port/export_core.dart';

import '../property/field_property.dart';
import '../record/value_object.dart';

extension PortFieldGeneratorExtension<V> on FieldProperty<V> {
  PortField toPortField() {
    return FieldAdapterFactory().resolveOrNull(this)!.toPortField(this);
  }

  PortField toOptionsPortField<T>(List<T> options, {bool canBeNone: false}) {
    return OptionsPortField(name: name, options: options, initialValue: getUnvalidated(), canBeNone: canBeNone);
  }
}

extension EmbeddedFieldGeneratorExtension<V extends ValueObject> on FieldProperty<V> {
  PortField toEmbeddedPortField(Port portBuilder(V? currentEmbeddedValue)) {
    return EmbeddedPortField(name: name, port: portBuilder(getUnvalidated()));
  }
}
