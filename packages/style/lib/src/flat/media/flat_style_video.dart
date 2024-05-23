import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:style/src/components/layout/styled_container.dart';
import 'package:style/src/components/media/styled_video.dart';
import 'package:style/src/components/misc/styled_loading_indicator.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';
import 'package:video_player/video_player.dart';

class FlatStyleVideoRenderer with IsTypedStyleRenderer<StyledVideo> {
  @override
  Widget renderTyped(BuildContext context, StyledVideo component) {
    return SizedBox(
      width: component.width,
      height: component.height,
      child: HookBuilder(
        builder: (context) {
          final videoValue = useValueListenable(component.videoPlayerController);
          final chewieController = useMemoized(
            () => ChewieController(
              videoPlayerController: component.videoPlayerController,
              autoInitialize: true,
              autoPlay: true,
              looping: true,
              showControlsOnInitialize: false,
              placeholder: StyledLoadingIndicator(),
              showControls: false,
            )..setVolume(0),
            [component.videoPlayerController],
          );
          useEffect(() {
            return () {
              component.videoPlayerController.dispose();
              chewieController.dispose();
            };
          }, [chewieController]);

          Widget widget = videoValue.isInitialized
              ? Chewie(controller: chewieController)
              : Padding(
                  padding: EdgeInsets.all(8),
                  child: StyledLoadingIndicator(),
                );
          if (videoValue.isInitialized) {
            widget = AspectRatio(aspectRatio: videoValue.aspectRatio, child: widget);
          }
          widget = Center(child: widget);
          return widget;
        },
      ),
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide
        .getTabByNameOrCreate('Media', icon: Icons.perm_media)
        .getSectionByNameOrCreate('Video')
        .add(StyledContainer.subtle(
      child: HookBuilder(
        builder: (context) {
          return StyledVideo(
            videoPlayerController: useMemoized(() => VideoPlayerController.networkUrl(
                  Uri.parse('http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'),
                )),
            width: 300,
          );
        },
      ),
    ));
  }
}
