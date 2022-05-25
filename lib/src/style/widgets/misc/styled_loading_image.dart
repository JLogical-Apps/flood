import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/widgets/misc/styled_loading_indicator.dart';
import 'package:transparent_image/transparent_image.dart';

class StyledLoadingImage extends StatelessWidget {
  final ImageProvider? image;

  final double? width;
  final double? height;
  final BoxFit fit;

  const StyledLoadingImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit: BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedOpacity(
            opacity: image == null ? 1 : 0,
            duration: Duration(milliseconds: 3100),
            child: StyledLoadingIndicator(),
          ),
        ),
        FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          image: image ?? MemoryImage(kTransparentImage),
          fit: fit,
          width: width,
          height: height,
        ),
      ],
    );
  }
}
