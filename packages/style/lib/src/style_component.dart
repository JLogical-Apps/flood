import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';

abstract class StyleComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = Provider.of<Style>(context);
    return style.render(context, this);
  }
}
