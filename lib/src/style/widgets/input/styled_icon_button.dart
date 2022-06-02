import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_button.dart';

class StyledIconButton extends StatelessWidget {
  final IconData icon;
  final void Function()? onTapped;

  final Color? color;

  const StyledIconButton({
    super.key,
    required this.icon,
    required this.onTapped,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return StyledButton.medium(
      icon: icon,
      color: color,
      onTapped: onTapped,
    );
  }
}
