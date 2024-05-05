import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_drop_core_component.dart';
import 'package:port_drop_core/src/port_generator_override.dart';
import 'package:utils_core/utils_core.dart';

extension PortDropValueObjectExtensions<V extends ValueObject> on V {
  Port<V> asPort(
    CorePondContext corePondContext, {
    List<String>? only,
    List<PortGeneratorOverride> overrides = const [],
    bool validateResult = true,
  }) {
    return corePondContext.locate<PortDropCoreComponent>().generatePort(
          this,
          only: only,
          overrides: overrides,
          validateResult: validateResult,
        );
  }
}
