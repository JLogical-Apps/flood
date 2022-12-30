import 'package:flutter/material.dart';
import 'package:style/src/emphasis.dart';
import 'package:style/src/style_component.dart';

class StyledButton extends StyleComponent {
  final Widget? label;
  final String? labelText;

  final Function()? onPressed;

  final Emphasis emphasis;

  StyledButton({
    this.label,
    this.labelText,
    required this.onPressed,
    this.emphasis = Emphasis.regular,
  });

  StyledButton.subtle({this.label, this.labelText, required this.onPressed}) : emphasis = Emphasis.subtle;

  StyledButton.strong({this.label, this.labelText, required this.onPressed}) : emphasis = Emphasis.strong;
}
