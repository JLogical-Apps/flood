import 'package:asset/src/asset_pickers/asset_picker.dart';
import 'package:asset/src/utils/xfile_extensions.dart';
import 'package:asset_core/asset_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:style/style.dart';

class AnyAssetPicker extends AssetPicker {
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
          titleText: 'Take Video',
          descriptionText: 'Take a video with your camera.',
          iconData: Icons.videocam,
          color: Colors.blue,
          onPerform: (_) {
            assetPicker = () async {
              final video = await ImagePicker().pickVideo(source: ImageSource.camera);
              return await video?.toAsset();
            };
          },
        ),
        ActionItem(
          titleText: 'Upload',
          descriptionText: 'Upload a photo or video from your gallery.',
          iconData: Icons.photo,
          color: Colors.greenAccent,
          onPerform: (_) async {
            assetPicker = () async {
              final image = await ImagePicker().pickMedia();
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
    return input == AllowedFileTypes.any;
  }
}
