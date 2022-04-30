import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/style_context.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_body_text.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../style.dart';
import '../../styled_widget.dart';
import 'styled_input_text.dart';
import 'styled_text.dart';
import 'styled_text_overrides.dart';
import 'styled_text_span.dart';

class StyledDescriptionText extends StyledWidget {
  final String inputString;
  final StyledTextOverrides? overrides;

  const StyledDescriptionText({
    Key? key,
    required this.inputString,
    this.overrides,
  });

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    String description = inputString;

    int numTags = '<'.allMatches(description).length;
    List<StyledText> result = [];

    if (numTags > 0) {
      for (var i = 0; i < numTags; i++) {
        String text = description.allBefore('<');
        text = text.allAfter('>');

        //Adds a new StyledBodyText that comes before the opening tags.
        result.add(StyledBodyText(description.allBefore('>' + text + '<')));

        //Removes the portion of the input that has been used
        description = description.replaceAll(description.allBefore('>' + text + '<') + '>' + text + '<', '');

        //Adds a new StyledInputText for the text found between the tags
        result.add(StyledInputText(text));
      }
    }

    //Adds any remaining text to a StyledBodyText
    result.add(StyledBodyText(description));

    return StyledTextSpan(children: result);
  }
}
