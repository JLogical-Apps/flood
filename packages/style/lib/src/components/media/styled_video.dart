import 'package:flutter/material.dart';
import 'package:style/src/style_component.dart';
import 'package:video_player/video_player.dart';

class StyledVideo extends StyleComponent {
  final VideoPlayerController videoPlayerController;
  final double? width;
  final double? height;
  final BoxFit? fit;

  StyledVideo({super.key, required this.videoPlayerController, this.width, this.height, this.fit});
}
