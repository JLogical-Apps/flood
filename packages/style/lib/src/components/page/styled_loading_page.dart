import 'package:flutter/material.dart';
import 'package:style/src/components/misc/styled_loading_indicator.dart';
import 'package:style/src/components/page/styled_page.dart';

class StyledLoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StyledPage(
      body: Center(
        child: StyledLoadingIndicator(),
      ),
    );
  }
}
