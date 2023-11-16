import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:style/src/action/action_item.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/components/misc/styled_scrollbar.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_component.dart';

class StyledPage extends StyleComponent {
  final Widget? title;
  final String? titleText;

  final Widget body;

  final List<Widget> actionWidgets;
  final List<ActionItem> actions;

  final FutureOr Function()? onRefresh;

  final bool canPop;

  final EdgeInsets innerPadding;

  StyledPage({
    this.title,
    this.titleText,
    required this.body,
    this.actionWidgets = const [],
    this.actions = const [],
    this.canPop = true,
    this.innerPadding = const EdgeInsets.all(4),
  }) : onRefresh = null;

  StyledPage.refreshable({
    this.title,
    this.titleText,
    Widget? body,
    List<Widget>? children,
    this.actionWidgets = const [],
    this.actions = const [],
    required FutureOr Function() this.onRefresh,
    this.canPop = true,
    this.innerPadding = const EdgeInsets.all(4),
  }) : body = _getRefreshableBody(
          body: body,
          children: children,
          onRefresh: onRefresh,
        );
}

Widget _getRefreshableBody({
  Widget? body,
  List<Widget>? children,
  required FutureOr Function() onRefresh,
}) {
  return HookBuilder(
    builder: (context) {
      final refreshController = useMemoized(() => RefreshController(initialRefresh: false));

      final colorPalette = context.colorPalette();

      var widget = children == null ? body! : StyledList.column.centered.scrollable(children: children);
      widget = SmartRefresher(
        controller: refreshController,
        header: WaterDropMaterialHeader(
          color: colorPalette.background.strong.foreground.regular,
          backgroundColor: colorPalette.background.strong,
        ),
        onRefresh: () async {
          await onRefresh();
          refreshController.refreshCompleted();
        },
        physics:ClampingScrollPhysics(),
        child: widget,
      );

      if (children != null) {
        widget = StyledScrollbar(child: widget);
      }

      return widget;
    },
  );
}
