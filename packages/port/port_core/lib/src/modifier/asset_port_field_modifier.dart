import 'package:port_core/port_core.dart';
import 'package:port_core/src/modifier/wrapper_port_field_node_modifier.dart';

class AssetPortFieldNodeModifier extends WrapperPortFieldNodeModifier<AssetPortField> {
  AssetPortFieldNodeModifier({required super.modifierGetter});

  @override
  AssetPortField? findAssetPortFieldOrNull(AssetPortField portField) {
    return portField;
  }
}
