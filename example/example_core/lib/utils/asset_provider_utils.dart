import 'package:example_core/components/testing_utility_component.dart';
import 'package:flood_core/flood_core.dart';

extension AssetProviderStaticExtensions on AssetProviderStatic {
  AssetProvider syncingOrAdapting<E extends Entity>(
    AssetCoreComponent context,
    String Function(AssetPathContext context) pathGetter,
  ) {
    if (context.context.testingComponent.useSyncing) {
      return syncing(
        context,
        pathGetter,
        sourceAssetProviderWrapper: (assetProvider) =>
            assetProvider.withCompression(context).fromRepository<E>(context),
      );
    } else {
      return adapting(
        context,
        pathGetter,
        sourceAssetProviderWrapper: (assetProvider) =>
            assetProvider.withCompression(context).fromRepository<E>(context),
      );
    }
  }
}
