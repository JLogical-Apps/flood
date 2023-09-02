import 'package:flutter/services.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:utils_core/utils_core.dart';

class AssetDataSource with IsDataSource<String> {
  final String assetPath;

  AssetDataSource(this.assetPath);

  @override
  Stream<String>? getXOrNull() async* {
    try {
      yield await rootBundle.loadString(assetPath);
    } catch (_) {}
  }

  @override
  Future<String?> getOrNull() async {
    return guardAsync(() => rootBundle.loadString(assetPath));
  }

  @override
  Future<void> set(String data) {
    throw Exception('Cannot set the value of an asset!');
  }

  @override
  Future<void> delete() {
    throw Exception('Cannot delete an asset!');
  }
}

extension AssetDataSourceStaticExtension on DataSourceStatic {
  AssetDataSource asset(String assetPath) {
    return AssetDataSource(assetPath);
  }
}
