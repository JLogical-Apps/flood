import 'dart:typed_data';

import 'package:asset/src/asset_builders/asset_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model/model.dart';
import 'package:persistence/persistence.dart';
import 'package:style/style.dart';

class ImageAssetBuilder extends AssetBuilder {
  @override
  Widget build(AssetBuilderContext assetBuilderContext) {
    final bytesModel = useMemoized(() => assetBuilderContext.assetReference.bytesDataSource.getX().asModel());
    return ModelBuilder(
      model: bytesModel,
      builder: (Uint8List bytes) {
        return StyledImage(image: MemoryImage(bytes));
      },
    );
  }

  @override
  bool shouldModify(AssetBuilderContext assetBuilderContext) {
    return true;
  }
}
