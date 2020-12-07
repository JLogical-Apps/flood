import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:vb_image_cache/vb_image_cache.dart';

/// Image that handles caching, and fade in animation.
class SmartImage extends StatelessWidget {
  /// The url of the image.
  final String url;

  final double width;
  final double height;

  const SmartImage({@required this.url, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: MemoryImage(kTransparentImage),
      image: VBCacheImage(url),
      width: width,
      height: height,
    );
  }
}
