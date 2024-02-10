import 'package:flutter/material.dart';

class StyledMessage {
  final Widget? label;
  final String? labelText;

  final Color? color;

  StyledMessage({this.label, this.labelText, this.color});

  StyledMessage.error({this.label, this.labelText}) : color = Colors.red;
}
