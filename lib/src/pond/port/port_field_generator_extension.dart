import 'package:jlogical_utils/src/pond/port/field/field_adapter_factory.dart';
import 'package:jlogical_utils/src/port/export_core.dart';

import '../property/field_property.dart';
import '../record/value_object.dart';

extension PortFieldGeneratorExtension<V> on FieldProperty<V> {
  PortField<V?> toPortField() {
    return FieldAdapterFactory().resolveOrNull(this)!.toPortField(this) as PortField<V?>;
  }

  PortField<V?> toOptionsPortField(List<V> options, {bool canBeNone: false}) {
    return OptionsPortField(name: name, options: options, initialValue: getUnvalidated(), canBeNone: canBeNone);
  }
}

extension EmbeddedFieldGeneratorExtension<V extends ValueObject> on FieldProperty<V> {
  PortField<Port> toEmbeddedPortField(Port portBuilder(V? currentEmbeddedValue)) {
    final value = getUnvalidated();
    return EmbeddedPortField(name: name, port: portBuilder(value), enabled: value != null);
  }
}

extension IntPortFieldGeneratorExtension on FieldProperty<int> {
  CurrencyPortField toCentsCurrencyPortField() {
    return CurrencyPortField(name: name, initialValue: getUnvalidated());
  }
}
