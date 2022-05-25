import 'asset.dart';

abstract class AssetProvider<A extends Asset<T>, T> {
  /// Creates a new asset with [value]. Uploads the asset.
  Future<A> create(T value);

  /// Returns the asset with [id].
  A from(String id);

  Type get assetType => A;
}
