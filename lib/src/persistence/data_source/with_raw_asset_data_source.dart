import 'package:flutter/services.dart';
import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

/// Gets a version from an asset.
mixin WithRawAssetDataSource on DataSource<ByteData> {
  String get assetPath;

  @override
  Future<ByteData?> getData() async {
    final configContents = await guard(() => rootBundle.load(assetPath));
    return configContents;
  }

  @override
  Future<void> saveData(ByteData data) {
    // Cannot save to an asset.
    throw UnimplementedError();
  }

  @override
  Future<Function> delete() {
    // Cannot delete an asset.
    throw UnimplementedError();
  }
}
