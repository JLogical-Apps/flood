import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:video_player/video_player.dart';

class StyledLoadingVideo extends HookWidget {
  final VideoPlayerController? video;

  final void Function()? onTapped;

  final double? width;
  final double? height;
  final BoxFit fit;
  final EdgeInsets? paddingOverride;
  final Alignment? alignment;

  const StyledLoadingVideo({
    super.key,
    required this.video,
    this.onTapped,
    this.width,
    this.height,
    this.fit: BoxFit.cover,
    this.paddingOverride,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final chewieController = useMemoized(
      () => video.mapIfNonNull((video) => ChewieController(
            videoPlayerController: video,
            autoInitialize: true,
            showOptions: onTapped == null,
            showControls: onTapped == null,
          )..setVolume(0)),
      [video],
    );

    return Stack(
      children: [
        SizedBox(
          width: width,
          height: height,
          child: AnimatedCrossFade(
            firstChild: chewieController != null ? Chewie(controller: chewieController) : StyledLoadingIndicator(),
            secondChild: AnimatedOpacity(
              opacity: video == null ? 1 : 0,
              duration: Duration(milliseconds: 500),
              child: StyledLoadingIndicator(isSpinning: video == null),
            ),
            alignment: alignment ?? Alignment.center,
            duration: Duration(milliseconds: 300),
            crossFadeState: CrossFadeState.showFirst,
          ),
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
