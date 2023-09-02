import 'package:flutter/material.dart';
import 'package:style/src/components/layout/styled_container.dart';
import 'package:style/src/components/media/styled_image.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';

class FlatStyleImageRenderer with IsTypedStyleRenderer<StyledImage> {
  @override
  Widget renderTyped(BuildContext context, StyledImage component) {
    return Image(
      image: component.image,
      width: component.width,
      height: component.height,
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
            width: 100,
            height: 100,
          ),
        ));
  }
}
