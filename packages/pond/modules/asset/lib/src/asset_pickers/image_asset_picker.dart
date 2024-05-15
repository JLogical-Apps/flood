import 'package:asset/src/asset_pickers/asset_picker.dart';
import 'package:asset/src/utils/xfile_extensions.dart';
import 'package:asset_core/asset_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:style/style.dart';

class ImageAssetPicker extends AssetPicker {
  @override
  Future<Asset?> pickAsset(BuildContext context, AllowedFileTypes allowedFileTypes) async {
    Future<Asset?> Function()? assetPicker;
    await context.showStyledDialog(StyledDialog.actionList(
      context: context,
      actions: [
        ActionItem(
          titleText: 'Take Photo',
          descriptionText: 'Take a photo with your camera.',
          iconData: Icons.camera_alt,
          color: Colors.blue,
          onPerform: (_) {
            assetPicker = () async {
              final image = await ImagePicker().pickImage(source: ImageSource.camera);
              return await image?.toAsset();
            };
          },
        ),
        ActionItem(
          titleText: 'Upload from Gallery',
          descriptionText: 'Upload a photo from your gallery.',
          iconData: Icons.photo,
          color: Colors.greenAccent,
          onPerform: (_) async {
            assetPicker = () async {
              final image = await ImagePicker().pickImage(source: ImageSource.gallery);
              return await image?.toAsset();
            };
          },
        ),
      ],
    ));
    if (assetPicker == null) {
      return null;
    }

    return await assetPicker!();
  }

  @override
  bool shouldModify(AllowedFileTypes input) {
    return input == AllowedFileTypes.image;
  }
}
