import 'asset.dart';

/// Specifies how to allow a user to pick an asset of type [A].
abstract class AssetPicker<A extends Asset<T>, T> {
  Future<A?> pickAsset();

  Type get assetType => A;
}
