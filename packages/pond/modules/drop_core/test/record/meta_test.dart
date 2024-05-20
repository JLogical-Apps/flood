import 'package:asset_core/asset_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('asset provider of property', () async {
    final assetCoreComponent = AssetCoreComponent(assetProviders: [
      TestAssetProvider(),
    ]);
    final corePondContext = CorePondContext();
    await corePondContext.register(assetCoreComponent);

    final data = Data1();
    final assetProvider = data.assetProperty.findAssetProvider(assetCoreComponent);
    expect(assetProvider, isNotNull);
  });
}

class Data1 extends ValueObject {
  static const assetField = 'asset';
  late final assetProperty =
      field<String>(name: assetField).asset(assetProvider: (context) => context.locate<TestAssetProvider>()).required();

  @override
  List<ValueObjectBehavior> get behaviors => [assetProperty];
}

class TestAssetProvider with IsAssetProviderWrapper {
  @override
  late final AssetProvider assetProvider = AssetProvider.static.memory;
}
