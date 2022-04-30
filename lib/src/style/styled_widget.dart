import 'package:flutter/widgets.dart';
import 'package:jlogical_utils/src/style/style.dart';
import 'package:jlogical_utils/src/style/style_builder.dart';
import 'package:jlogical_utils/src/style/style_context.dart';

/// The base class for widgets that are rendered by a [Style].
/// Override [buildStyled] to call the [Style]'s builder method.
abstract class StyledWidget extends StatelessWidget {
  const StyledWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyleBuilder(builder: buildStyled);
  }

  /// Builds the styled widget based on the [style] and [styleContext].
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext);
}
