import 'package:asset_core/src/asset_core_component.dart';
import 'package:pond_core/pond_core.dart';
import 'package:utils_core/utils_core.dart';

extension CorePondContextExtensions on CorePondContext {
  AssetCoreComponent get assetCoreComponent => locate<AssetCoreComponent>();
}
