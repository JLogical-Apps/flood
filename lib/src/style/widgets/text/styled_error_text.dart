import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class StyledErrorText extends StatelessWidget {
  final String text;

  const StyledErrorText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyledBodyText(
      text,
      textOverrides: StyledTextOverrides(fontColor: Colors.red, padding: EdgeInsets.zero),
    );
  }
}
