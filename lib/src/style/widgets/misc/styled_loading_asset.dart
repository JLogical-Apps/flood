import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/src/style/widgets/misc/styled_loading_indicator.dart';

import '../../../model/export_core.dart';
import '../../../pond/export.dart';
import '../../../utils/hook_utils.dart';
import '../text/styled_error_text.dart';
import 'styled_loading_image.dart';
import 'styled_loading_video.dart';

class StyledLoadingAsset extends HookWidget {
  final FutureValue<Asset?> maybeAsset;

  final void Function()? onTapped;

  final double? width;
  final double? height;
  final BoxFit fit;
  final EdgeInsets? paddingOverride;
  final Alignment? alignment;

  /// Widget to display if there is no asset.
  final Widget? emptyWidget;

  const StyledLoadingAsset({
    super.key,
    required this.maybeAsset,
    this.onTapped,
    this.width,
    this.height,
    this.fit: BoxFit.cover,
    this.paddingOverride,
    this.alignment,
    this.emptyWidget,
  });

  StyledLoadingAsset.loaded({
    super.key,
    required Asset? asset,
    this.onTapped,
    this.width,
    this.height,
    this.fit: BoxFit.cover,
    this.paddingOverride,
    this.alignment,
    this.emptyWidget,
  }) : maybeAsset = FutureValue.loaded(value: asset);

  @override
  Widget build(BuildContext context) {
    final assetFile = useState<File?>(null);

    useMemoizedFuture(
      () => () async {
        assetFile.value = await maybeAsset.getOrNull()?.ensureCachedToFile();
      }(),
      [maybeAsset.getOrNull()?.value.hashCode],
    );

    return maybeAsset.when(
      initial: () {
        return SizedBox(
          width: width,
          height: height,
          child: StyledLoadingIndicator(),
        );
      },
      loaded: (asset) {
        if (asset == null) {
          return emptyWidget ?? SizedBox.shrink();
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
            videoFile: assetFile.value,
            onTapped: onTapped,
            width: width,
            height: height,
            fit: fit,
            paddingOverride: paddingOverride,
            alignment: alignment,
          );
        }

        return StyledErrorText('Unable to render asset!');
      },
      error: (error) {
        return StyledErrorText(error.toString());
      },
    );
  }
}
