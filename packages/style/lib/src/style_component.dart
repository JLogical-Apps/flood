import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';

abstract class StyleComponent extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final style = Provider.of<Style>(context);
    return style.render(context, this);
  }
}
