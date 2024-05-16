import 'package:asset_core/asset_core.dart';
import 'package:flutter/material.dart';
import 'package:pond/pond.dart';

extension BuildContextExtensions on BuildContext {
  AssetCoreComponent get assetCoreComponent => find<AssetCoreComponent>();
}

extension AppPondContextExtensions on AppPondContext {
  AssetCoreComponent get assetCoreComponent => find<AssetCoreComponent>();
}
