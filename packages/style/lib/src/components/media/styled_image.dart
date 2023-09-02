import 'package:flutter/material.dart';
import 'package:style/src/style_component.dart';

class StyledImage extends StyleComponent {
  final ImageProvider image;
  final double? width;
  final double? height;
  final BoxFit? fit;

  StyledImage({super.key, required this.image, this.width, this.height, this.fit});

  StyledImage.asset(String assetPath, {super.key, this.width, this.height, this.fit}) : image = AssetImage(assetPath);
}
