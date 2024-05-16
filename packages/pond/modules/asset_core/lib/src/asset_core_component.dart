import 'package:asset_core/src/asset_providers/asset_provider.dart';
import 'package:pond_core/pond_core.dart';
import 'package:utils_core/utils_core.dart';

class AssetCoreComponent with IsCorePondComponent, IsLocatorWrapper<AssetProvider> {
  final List<AssetProvider> assetProviders;

  @override
  late Locator<AssetProvider> locator;

  AssetCoreComponent({required this.assetProviders});

  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior(onRegister: (context, component) async {
          locator = Locator<AssetProvider>();
          for (final assetProvider in assetProviders) {
            await locator.register(assetProvider);
          }
        }),
      ];
}
