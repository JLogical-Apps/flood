import 'package:flutter/widgets.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/style/style_builder.dart';

abstract class StyledWidget extends StatelessWidget {
  const StyledWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyleBuilder(builder: buildStyled);
  }

  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext);
}
