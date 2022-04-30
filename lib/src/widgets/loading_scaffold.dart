import 'package:flutter/material.dart';

import 'export.dart';

/// Util widget of an empty scaffold with a centered loading icon.
class LoadingScaffold extends StatelessWidget {
  const LoadingScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingWidget(),
    );
  }
}
