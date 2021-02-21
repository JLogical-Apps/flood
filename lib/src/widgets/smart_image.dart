import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

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
      image: CachedNetworkImageProvider(url),
      width: width,
      height: height,
    );
  }
}
