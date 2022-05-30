import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:video_player/video_player.dart';
import '../../../model/export_core.dart';
import '../../../utils/hook_utils.dart';
import '../text/styled_error_text.dart';
import 'styled_loading_image.dart';
import 'styled_loading_video.dart';
import 'package:jlogical_utils/src/style/widgets/misc/styled_loading_indicator.dart';

import '../../../pond/export.dart';

class StyledLoadingAsset extends HookWidget {
  final String assetId;

  final void Function()? onTapped;

  final double? width;
  final double? height;
  final BoxFit fit;
  final EdgeInsets? paddingOverride;
  final Alignment? alignment;

  const StyledLoadingAsset({
    super.key,
    required this.assetId,
    this.onTapped,
    this.width,
    this.height,
    this.fit: BoxFit.cover,
    this.paddingOverride,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final assetModel = useModel(locate<AssetModule>().getAssetModel(assetId));
    final asset = assetModel.getOrNull();

    final assetFile = useState<File?>(null);

    useListen(
      assetModel.valueX,
      (FutureValue<Asset?> maybeAsset) async {
        final asset = maybeAsset.getOrNull();
        if (asset == null) {
          return;
        }

        assetFile.value = await asset.ensureCachedToFile();
      },
    );

    if (asset == null) {
      return SizedBox(
        width: width,
        height: height,
        child: StyledLoadingIndicator(),
      );
    }

    if (asset.isImage) {
      return StyledLoadingImage(
        image: MemoryImage(asset.value),
        onTapped: onTapped,
        width: width,
        height: height,
        fit: fit,
        paddingOverride: paddingOverride,
        alignment: alignment,
      );
    }

    if (asset.isVideo) {
      return StyledLoadingVideo(
        video: assetFile.value.mapIfNonNull((file) => VideoPlayerController.file(file)),
        onTapped: onTapped,
        width: width,
        height: height,
        fit: fit,
        paddingOverride: paddingOverride,
        alignment: alignment,
      );
    }

    return StyledErrorText('Unable to render asset!');
  }
}
