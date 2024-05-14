import 'package:asset_core/asset_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('asset provider of property', () {
    final data = Data1();
    final assetProvider = data.assetProperty.findAssetProvider();
    expect(assetProvider, isNotNull);
  });
}

class Data1 extends ValueObject {
  static const assetField = 'asset';
  late final assetProperty =
      field<String>(name: assetField).asset(assetProvider: AssetProvider.static.memory).required();

  @override
  List<ValueObjectBehavior> get behaviors => [assetProperty];
}
