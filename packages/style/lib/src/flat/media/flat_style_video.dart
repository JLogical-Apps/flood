import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/style.dart';

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
              showControls: false,
            ),
            [component.videoPlayerController],
          );
          useEffect(() {
            return () {
              component.videoPlayerController.dispose();
              chewieController.dispose();
            };
          }, [chewieController]);

          return Center(
            child: AspectRatio(
              aspectRatio: videoValue.aspectRatio,
              child: videoValue.isInitialized ? Chewie(controller: chewieController) : StyledLoadingIndicator(),
            ),
          );
        },
      ),
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide
        .getTabByNameOrCreate('Media', icon: Icons.perm_media)
        .getSectionByNameOrCreate('Video')
        .add(StyledContainer(
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
