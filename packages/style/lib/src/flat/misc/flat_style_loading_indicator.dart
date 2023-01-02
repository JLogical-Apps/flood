import 'package:flutter/material.dart';
import 'package:style/src/components/layout/styled_container.dart';
import 'package:style/src/components/misc/styled_loading_indicator.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';

class FlatStyleLoadingIndicatorRenderer with IsTypedStyleRenderer<StyledLoadingIndicator> {
  @override
  Widget renderTyped(BuildContext context, StyledLoadingIndicator component) {
    return CircularProgressIndicator(
      color: context.colorPalette().foreground.strong,
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getTabByNameOrCreate('Misc', icon: Icons.interests).getSectionByNameOrCreate('Loading')
      ..add(StyledLoadingIndicator())
      ..add(StyledContainer.strong(child: StyledLoadingIndicator()));
  }
}
