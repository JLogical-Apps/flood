import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

/// Scaffold that has handles pull-to-refresh.
class RefreshScaffold extends StatelessWidget {
  final PreferredSize? appBar;

  final Widget body;

  /// Function to call when refreshing.
  final Future<void> Function() onRefresh;

  const RefreshScaffold({this.appBar, required this.body, required this.onRefresh}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: LiquidPullToRefresh(
        child: body,
        onRefresh: onRefresh,
      ),
    );
  }
}
