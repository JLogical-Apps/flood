import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/port_drop_core.dart';
import 'package:type/type.dart';
import 'package:utils_core/utils_core.dart';

extension StagePortFieldExtensions on StagePortField<RuntimeType?, dynamic> {
  V? toValueObject<V extends ValueObject>({
    required PortDropCoreComponent context,
    required RuntimeType? value,
  }) {
    final port = value == this.value.value ? this.value.port : getMappedPort(value);
    return port?.mapIfNonNull((port) => context.getValueObjectFromPort<V>(
          port: port,
          valueObjectType: port.submitType,
        ));
  }
}
