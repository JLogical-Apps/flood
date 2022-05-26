import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../../utils/hook_utils.dart';
import '../../context/app_context.dart';
import 'asset.dart';
import 'asset_module.dart';

T? useAssetOrNull<A extends Asset<T>, T>(String? id) {
  return useModelOrNull(id.mapIfNonNull((id) => locate<AssetModule>().getAssetModel<A, T>(id)))?.getOrNull();
}

T? useAsset<A extends Asset<T>, T>(String id) {
  return useAssetOrNull<A, T>(id);
}

List<T?> useAssets<A extends Asset<T>, T>(List<String> ids) {
  return useModels(ids.map((id) => locate<AssetModule>().getAssetModel<A, T>(id)).toList())
      .map((model) => model.getOrNull())
      .toList();
}
