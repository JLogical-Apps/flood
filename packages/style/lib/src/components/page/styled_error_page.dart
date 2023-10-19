import 'package:flutter/material.dart';
import 'package:style/src/components/page/styled_page.dart';
import 'package:style/src/components/text/styled_text.dart';

class StyledErrorPage extends StatelessWidget {
  final dynamic error;
  final StackTrace stackTrace;

  StyledErrorPage({required this.error, required this.stackTrace});

  @override
  Widget build(BuildContext context) {
    return StyledPage(
      body: Center(
        child: StyledText.body.error('$error\n$stackTrace'),
      ),
    );
  }
}
