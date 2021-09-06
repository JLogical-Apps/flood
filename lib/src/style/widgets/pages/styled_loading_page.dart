import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/style/widgets/misc/styled_loading_indicator.dart';

/// Page that indicates data is loading.
class StyledLoadingPage extends StatelessWidget {
  const StyledLoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyledPage(body: Center(child: StyledLoadingIndicator()));
  }
}
