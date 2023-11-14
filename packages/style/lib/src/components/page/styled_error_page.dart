import 'package:flutter/material.dart';
import 'package:style/src/components/page/styled_page.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:utils/utils.dart';

class StyledErrorPage extends StatelessWidget {
  final dynamic error;
  final StackTrace? stackTrace;

  StyledErrorPage({required this.error, this.stackTrace});

  @override
  Widget build(BuildContext context) {
    return StyledPage(
      body: Center(
        child: StyledText.body.error([error, stackTrace].whereNonNull().join('\n')),
      ),
    );
  }
}
