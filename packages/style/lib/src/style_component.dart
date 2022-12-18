import 'package:flutter/material.dart';
import 'package:style/src/flat/flat_style.dart';

abstract class StyleComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatStyle().render(this);
  }
}
