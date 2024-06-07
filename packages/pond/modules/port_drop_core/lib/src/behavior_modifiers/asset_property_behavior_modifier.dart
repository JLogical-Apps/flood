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
    final assetProvider = behavior.assetProvider(context.corePondContext.assetCoreComponent);
    final assetId = behavior.value?.id;
    return PortField.asset(
      initialValue: assetId == null ? null : assetProvider.getById(assetId),
      assetProvider: assetProvider,
      uploadedAsset: behavior.duplicatedAsset,
    ).withAllowedFileTypes(behavior.allowedFileTypes ?? AllowedFileTypes.any);
  }
}
