import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';

class FlatStyleTextRenderer with IsTypedStyleRenderer<StyledText> {
  @override
  Widget renderTyped(BuildContext context, StyledText component) {
    final baseTextStyle = component.isDisplay ? GoogleFonts.urbanist : GoogleFonts.roboto;
    return Padding(
      padding: component.padding ?? EdgeInsets.zero,
      child: Text(
        component.text,
        textAlign: component.textAlign,
        style: baseTextStyle(
          fontSize: component.size.toDouble(),
          color: component.isError
              ? context.colorPalette().error.regular
              : component.color ?? context.colorPalette().foreground.getByEmphasis(component.emphasis),
          fontStyle: component.fontStyle,
          fontWeight: component.fontWeight,
        ),
        overflow: TextOverflow.fade,
      ),
    );
  }
}
