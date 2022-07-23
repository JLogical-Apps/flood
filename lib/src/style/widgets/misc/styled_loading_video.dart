import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/src/style/widgets/misc/styled_loading_indicator.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

class StyledLoadingVideo extends HookWidget {
  final File? videoFile;

  final void Function()? onTapped;

  final double? width;
  final double? height;
  final BoxFit fit;
  final EdgeInsets? paddingOverride;
  final Alignment? alignment;

  const StyledLoadingVideo({
    super.key,
    required this.videoFile,
    this.onTapped,
    this.width,
    this.height,
    this.fit: BoxFit.cover,
    this.paddingOverride,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final betterPlayerController = useMemoized(
      () {
        final controller = videoFile.mapIfNonNull((videoFile) => BetterPlayerController(
              BetterPlayerConfiguration(
                autoPlay: true,
                looping: true,
                controlsConfiguration: BetterPlayerControlsConfiguration(showControls: onTapped == null),
              ),
              betterPlayerDataSource: BetterPlayerDataSource.file(videoFile.path),
            )..setVolume(0));
        if (controller != null) {
          controller.addEventsListener((BetterPlayerEvent event) {
            if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
              controller.setOverriddenAspectRatio(controller.videoPlayerController!.value.aspectRatio);
            }
          });
        }
        return controller;
      },
      [videoFile?.path],
    );

    return Stack(
      children: [
        SizedBox(
          width: width,
          height: height,
          child: betterPlayerController == null
              ? StyledLoadingIndicator()
              : BetterPlayer(controller: betterPlayerController),
        ),
        if (onTapped != null)
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTapped,
              ),
            ),
          ),
      ],
    );
  }
}
