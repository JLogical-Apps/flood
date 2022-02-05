import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// A utility widget of a Column wrapped in a SingleChildScrollView with an optional Scrollbar.
class ScrollColumn extends HookWidget {
  /// Whether to show a Scrollbar.
  final bool withScrollbar;

  /// The children of the column.
  final List<Widget> children;

  final Future Function()? onRefresh;

  final CrossAxisAlignment crossAxisAlignment;

  const ScrollColumn({
    Key? key,
    this.withScrollbar: false,
    required this.children,
    this.onRefresh,
    this.crossAxisAlignment: CrossAxisAlignment.center,
  }) : super(key: key);

  const ScrollColumn.withScrollbar({
    Key? key,
    required List<Widget> children,
    Future Function()? onRefresh,
    CrossAxisAlignment crossAxisAlignment: CrossAxisAlignment.center,
  }) : this(key: key, withScrollbar: true, children: children, onRefresh: onRefresh);

  @override
  Widget build(BuildContext context) {
    Widget scrollView = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      ),
      physics: BouncingScrollPhysics(),
    );
    if (onRefresh != null) {
      final refreshController = useMemoized(() => RefreshController());
      scrollView = SmartRefresher(
        controller: refreshController,
        onRefresh: () async {
          await onRefresh!();
          refreshController.refreshCompleted();
        },
        child: scrollView,
      );
    }
    return withScrollbar ? Scrollbar(child: scrollView) : scrollView;
  }
}
