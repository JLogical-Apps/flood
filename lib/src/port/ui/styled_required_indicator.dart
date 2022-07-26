import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../style/export.dart';

class StyledRequiredIndicator extends HookWidget {
  final Widget child;

  const StyledRequiredIndicator({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        StyledBodyText(
          '*',
          textOverrides: StyledTextOverrides(
            fontWeight: FontWeight.bold,
            fontColor: context.styleContext().emphasisColor,
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
