import 'package:asset_core/asset_core.dart';
import 'package:auth_core/auth_core.dart';
import 'package:collection/collection.dart';
import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:utils_core/utils_core.dart';

const entityIdWildcard = '{entityId}';

class AssetCoreComponent with IsCorePondComponent, IsLocatorWrapper<AssetProvider> {
  final List<AssetProvider> Function(AssetCoreComponent context) assetProviders;
  final List<AssetProviderImplementation> assetProviderImplementations;
  final Account? Function()? loggedInAccountGetter;

  @override
  late Locator<AssetProvider> locator;

  AssetCoreComponent({
    required this.assetProviders,
    this.assetProviderImplementations = const [],
    this.loggedInAccountGetter,
  });

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

  AssetProvider? getByAssetPathOrNull(
    String assetPath, {
    Map<String, dynamic> wildcards = const {State.idField: entityIdWildcard},
  }) {
    final assetPathContext = AssetPathContext(context: this, values: wildcards);
    return assetProviders(this).firstWhereOrNull((assetProvider) =>
        AssetProviderMetaModifier.getModifier(assetProvider).getPath(assetProvider, assetPathContext) == assetPath);
  }

  AssetProvider getByAssetPath(
    String assetPath, {
    Map<String, dynamic> wildcards = const {State.idField: entityIdWildcard},
  }) {
    return getByAssetPathOrNull(assetPath, wildcards: wildcards) ??
        (throw Exception('Could not find asset provider that handles $assetPath'));
  }

  Account? getLoggedInAccount() {
    return loggedInAccountGetter?.call();
  }
}
