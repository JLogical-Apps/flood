import 'package:asset/src/asset_pickers/any_asset_picker.dart';
import 'package:asset/src/asset_pickers/image_asset_picker.dart';
import 'package:asset/src/asset_pickers/video_asset_picker.dart';
import 'package:asset_core/asset_core.dart';
import 'package:flutter/material.dart';
import 'package:utils/utils.dart';

abstract class AssetPicker with IsModifier<AllowedFileTypes> {
  Future<Asset?> pickAsset(BuildContext context, AllowedFileTypes allowedFileTypes);

  static final assetPickerResolver = ModifierResolver<AssetPicker, AllowedFileTypes>(modifiers: [
    ImageAssetPicker(),
    VideoAssetPicker(),
    AnyAssetPicker(),
  ]);

  static AssetPicker getAssetPicker(AllowedFileTypes allowedFileTypes) {
    return assetPickerResolver.resolveOrNull(allowedFileTypes) ??
        (throw Exception('Could not find asset picker for [$allowedFileTypes]!'));
  }

  static Future<Asset?> select(BuildContext context, AllowedFileTypes allowedFileTypes) {
    return getAssetPicker(allowedFileTypes).pickAsset(context, allowedFileTypes);
  }
}
