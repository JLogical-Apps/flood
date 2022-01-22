import 'package:flutter/services.dart';
import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';
import 'package:jlogical_utils/src/utils/util.dart';

/// Gets a version from an asset.
mixin WithAssetDataSource on DataSource<String> {
  String get assetPath;

  @override
  Future<String?> getData() async {
    final configContents = await guard(() => rootBundle.loadString(assetPath));
    return configContents;
  }

  @override
  Future<void> saveData(String data) {
    // Cannot save to an asset.
    throw UnimplementedError();
  }

  @override
  Future<Function> delete() {
    // Cannot delete an asset.
    throw UnimplementedError();
  }
}
