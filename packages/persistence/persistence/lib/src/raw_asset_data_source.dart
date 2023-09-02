import 'package:flutter/services.dart';
import 'package:persistence_core/persistence_core.dart';

class RawAssetDataSource with IsDataSource<ByteData> {
  final String assetPath;

  RawAssetDataSource(this.assetPath);

  @override
  Stream<ByteData>? getXOrNull() async* {
    yield await rootBundle.load(assetPath);
  }

  @override
  Future<void> set(ByteData data) {
    throw Exception('Cannot set the value of an asset!');
  }

  @override
  Future<void> delete() {
    throw Exception('Cannot delete an asset!');
  }
}

extension RawAssetDataSourceStaticExtension on DataSourceStatic {
  RawAssetDataSource rawAsset(String assetPath) {
    return RawAssetDataSource(assetPath);
  }
}
