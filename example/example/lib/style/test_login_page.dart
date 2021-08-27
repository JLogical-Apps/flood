import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class TestLoginPage extends HookWidget {
  final Style style;

  const TestLoginPage({
    Key? key,
    required this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyleProvider(
      style: style,
      child: StyledPage(
        body: ScrollColumn.withScrollbar(
          children: [],
        ),
      ),
    );
  }
}
