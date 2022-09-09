import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../../model/export_core.dart';
import '../../../utils/hook_utils.dart';
import '../../context/app_context.dart';
import 'asset.dart';
import 'asset_module.dart';
import 'asset_provider.dart';

FutureValue<Asset?>? useAssetOrNull(String? id, {AssetProvider? assetProvider}) {
  return useModelOrNull(id.mapIfNonNull((id) => locate<AssetModule>().getAssetModel(id, assetProvider: assetProvider)))
      ?.value;
}

FutureValue<Asset?> useAsset(String id, {AssetProvider? assetProvider}) {
  return useAssetOrNull(id, assetProvider: assetProvider)!;
}

List<FutureValue<Asset?>> useAssets(List<String> ids, {AssetProvider? assetProvider}) {
  return useModels(ids.map((id) => locate<AssetModule>().getAssetModel(id, assetProvider: assetProvider)).toList())
      .map((model) => model.value)
      .toList();
}
