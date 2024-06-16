import 'package:asset_core/src/asset_core_component.dart';
import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';

class AssetPathContext {
  final AssetCoreComponent context;
  final Map<String, dynamic> values;

  AssetPathContext({required this.context, this.values = const {}});
}

extension AssetPathContextExtensions on AssetPathContext {
  CorePondContext get corePondContext => context.context;

  DropCoreComponent get dropCoreComponent => context.context.dropCoreComponent;
}
