import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

/// Scaffold that has handles pull-to-refresh.
class RefreshScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;

  /// Function to call when refreshing.
  final Future<void> Function() onRefresh;

  /// The background color of the refresher.
  final Color? refresherBackgroundColor;

  const RefreshScaffold({this.appBar, required this.body, required this.onRefresh, this.refresherBackgroundColor}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: LiquidPullToRefresh(
        child: body,
        onRefresh: onRefresh,
        backgroundColor: Colors.white,
        color: refresherBackgroundColor ?? Theme.of(context).primaryColor,
        animSpeedFactor: 2.5,
        showChildOpacityTransition: false,
      ),
    );
  }
}
