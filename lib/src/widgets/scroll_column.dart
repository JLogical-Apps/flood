import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/src/style/style.dart';
import 'package:jlogical_utils/src/style/style_context.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../style/styled_widget.dart';

/// A utility widget of a Column wrapped in a SingleChildScrollView with an optional Scrollbar.
class ScrollColumn extends HookWidget {
  final ScrollController? controller;

  /// Whether to show a Scrollbar.
  final bool withScrollbar;

  /// The children of the column.
  final List<Widget> children;

  final Future Function()? onRefresh;

  /// Override the refresh-"header" when [onRefresh] is set.
  final Widget? headerOverride;

  final CrossAxisAlignment crossAxisAlignment;

  const ScrollColumn({
    Key? key,
    this.controller,
    this.withScrollbar: false,
    required this.children,
    this.onRefresh,
    this.headerOverride,
    this.crossAxisAlignment: CrossAxisAlignment.center,
  }) : super(key: key);

  const ScrollColumn.withScrollbar({
    Key? key,
    this.controller,
    this.withScrollbar: true,
    required this.children,
    this.onRefresh,
    this.headerOverride,
    this.crossAxisAlignment: CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    Widget scrollView = SingleChildScrollView(
      controller: controller,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      ),
      physics: BouncingScrollPhysics(),
    );
    if (onRefresh != null) {
      final refreshController = useMemoized(() => RefreshController());
      scrollView = SmartRefresher(
        header: headerOverride ?? _StyledHeader(),
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

class _StyledHeader extends StyledWidget {
  const _StyledHeader({Key? key}) : super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return WaterDropMaterialHeader(
      color: styleContext.emphasisColor,
      backgroundColor: styleContext.backgroundColorSoft,
    );
  }
}
