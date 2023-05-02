import 'package:flutter/material.dart';
import 'package:style/src/components/layout/styled_container.dart';
import 'package:style/src/components/misc/styled_loading_indicator.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';

class FlatStyleLoadingIndicatorRenderer with IsTypedStyleRenderer<StyledLoadingIndicator> {
  @override
  Widget renderTyped(BuildContext context, StyledLoadingIndicator component) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 30,
        maxHeight: 30,
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: CircularProgressIndicator(
          color: context.colorPalette().foreground.strong,
          strokeWidth: 3,
        ),
      ),
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getTabByNameOrCreate('Misc', icon: Icons.interests).getSectionByNameOrCreate('Loading')
      ..add(StyledLoadingIndicator())
      ..add(StyledContainer.strong(child: StyledLoadingIndicator()));
  }
}
