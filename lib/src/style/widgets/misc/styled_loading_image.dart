import 'package:flutter/material.dart';
import 'package:image_fade/image_fade.dart';
import 'package:jlogical_utils/src/style/widgets/misc/styled_loading_indicator.dart';
import 'package:transparent_image/transparent_image.dart';

class StyledLoadingImage extends StatelessWidget {
  final ImageProvider? image;

  final void Function()? onTapped;

  final double? width;
  final double? height;
  final BoxFit fit;
  final EdgeInsets? paddingOverride;
  final Alignment? alignment;

  const StyledLoadingImage({
    super.key,
    required this.image,
    this.onTapped,
    this.width,
    this.height,
    this.fit: BoxFit.cover,
    this.paddingOverride,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ImageFade(
          image: image ?? MemoryImage(kTransparentImage),
          placeholder: AnimatedOpacity(
              opacity: image == null ? 1 : 0,
              duration: Duration(milliseconds: 500),
              child: StyledLoadingIndicator(isSpinning: image == null)),
          alignment: alignment ?? Alignment.center,
          fit: fit,
          width: width,
          height: height,
          curve: Curves.easeInOutCubic,
        ),
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
