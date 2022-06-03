import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../../model/export_core.dart';
import '../../../utils/hook_utils.dart';
import '../../context/app_context.dart';
import 'asset.dart';
import 'asset_module.dart';

FutureValue<Asset?>? useAssetOrNull(String? id) {
  return useModelOrNull(id.mapIfNonNull((id) => locate<AssetModule>().getAssetModel(id)))?.value;
}

FutureValue<Asset?> useAsset(String id) {
  return useAssetOrNull(id)!;
}

List<FutureValue<Asset?>> useAssets(List<String> ids) {
  return useModels(ids.map((id) => locate<AssetModule>().getAssetModel(id)).toList())
      .map((model) => model.value)
      .toList();
}
