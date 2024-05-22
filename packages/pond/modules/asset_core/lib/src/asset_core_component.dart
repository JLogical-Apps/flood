import 'package:asset_core/src/asset_provider_implementation.dart';
import 'package:asset_core/src/asset_providers/asset_provider.dart';
import 'package:collection/collection.dart';
import 'package:pond_core/pond_core.dart';
import 'package:utils_core/utils_core.dart';

class AssetCoreComponent with IsCorePondComponent, IsLocatorWrapper<AssetProvider> {
  final List<AssetProvider> Function(AssetCoreComponent context) assetProviders;
  final List<AssetProviderImplementation> assetProviderImplementations;

  @override
  late Locator<AssetProvider> locator;

  AssetCoreComponent({required this.assetProviders, this.assetProviderImplementations = const []});

  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior(
          onRegister: (context, component) async {
            locator = Locator<AssetProvider>();
            for (final assetProvider in assetProviders(this)) {
              await locator.register(assetProvider);
            }
          },
          onReset: (context, component) async {
            for (final assetProvider in assetProviders(this)) {
              await assetProvider.reset();
            }
          },
        ),
      ];

  AssetProvider? getImplementationOrNull(AssetProvider assetProvider) {
    return assetProviderImplementations
        .firstWhereOrNull((implementation) => implementation.assetProviderType == assetProvider.runtimeType)
        ?.getImplementation(assetProvider);
  }

  AssetProvider getImplementation(AssetProvider assetProvider) {
    return getImplementationOrNull(assetProvider) ??
        (throw Exception('Could not find implementation for asset provider [$assetProvider]'));
  }
}
