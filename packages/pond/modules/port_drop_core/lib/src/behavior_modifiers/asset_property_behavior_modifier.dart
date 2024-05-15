import 'package:asset_core/asset_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';

class AssetPropertyBehaviorModifier extends WrapperPortGeneratorBehaviorModifier<AssetValueObjectProperty> {
  @override
  PortField getPortField(
    AssetValueObjectProperty behavior,
    PortField sourcePortField,
    PortGeneratorBehaviorModifierContext context,
  ) {
    return PortField.asset(initialValue: behavior.value, assetProvider: behavior.assetProvider)
        .withAllowedFileTypes(behavior.allowedFileTypes ?? AllowedFileTypes.any);
  }
}
