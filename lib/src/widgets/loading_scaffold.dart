import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

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
