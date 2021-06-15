import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// Scaffold that has handles pull-to-refresh.
class RefreshScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationCard;

  /// Function to call when refreshing.
  final Future<void> Function() onRefresh;

  /// The background color of the refresher.
  final Color? refresherBackgroundColor;

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  RefreshScaffold({this.appBar, required this.body, this.bottomNavigationCard, required this.onRefresh, this.refresherBackgroundColor}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: () async {
          await this.onRefresh();
          _refreshController.refreshCompleted();
        },
        child: body,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
