import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/widgets/pages/styled_page.dart';

import '../text/styled_error_text.dart';

/// Page that shows an error.
class StyledErrorPage extends StatelessWidget {
  final dynamic error;

  const StyledErrorPage({Key? key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyledPage(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StyledErrorText(error.toString()),
        ],
      ),
    );
  }
}
