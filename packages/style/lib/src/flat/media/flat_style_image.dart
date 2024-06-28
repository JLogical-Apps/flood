import 'package:flutter/material.dart';
import 'package:style/src/components/layout/styled_container.dart';
import 'package:style/src/components/media/styled_image.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';
import 'package:transparent_image/transparent_image.dart';

class FlatStyleImageRenderer with IsTypedStyleRenderer<StyledImage> {
  @override
  Widget renderTyped(BuildContext context, StyledImage component) {
    return FadeInImage(
      image: component.image,
      placeholder: MemoryImage(kTransparentImage),
      width: component.width,
      height: component.height,
      placeholderFit: component.fit,
      fadeInDuration: Duration(milliseconds: 300),
      fit: component.fit,
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide
        .getTabByNameOrCreate('Media', icon: Icons.perm_media)
        .getSectionByNameOrCreate('Image')
        .add(StyledContainer(
          child: StyledImage.asset(
            'assets/logo_foreground.png',
            height: 100,
          ),
        ));
  }
}
