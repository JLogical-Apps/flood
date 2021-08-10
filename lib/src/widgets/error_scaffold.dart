import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

/// Util widget of a scaffold with a centered error text.
class ErrorScaffold extends StatelessWidget {
  final dynamic error;

  const ErrorScaffold({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ErrorText(
          error.toString(),
          error: error,
        ),
      ),
    );
  }
}
