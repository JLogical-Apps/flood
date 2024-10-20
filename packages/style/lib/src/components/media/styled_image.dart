import 'package:flutter/material.dart';
import 'package:style/src/style_component.dart';

class StyledImage extends StyleComponent {
  final ImageProvider image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  StyledImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit,
    this.errorBuilder,
  });

  StyledImage.asset(
    String assetPath, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.errorBuilder,
  }) : image = AssetImage(assetPath);

  StyledImage.network(
    String imageUrl, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.errorBuilder,
  }) : image = NetworkImage(imageUrl);
}
