import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class DateChip extends StatelessWidget {
  final DateTime date;

  const DateChip({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return StyledContainer.subtle(
      padding: EdgeInsets.all(5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            width: 0.4,
            color: context.colorPalette().foreground.regular,
          )),
      child: Column(
        children: [
          StyledText.body.centered.strong(date.formatWith((dateFormat) => dateFormat.add_MMMd())),
          StyledText.body.centered(date.formatWith((dateFormat) => dateFormat.add_y())),
        ],
      ),
    );
  }
}
