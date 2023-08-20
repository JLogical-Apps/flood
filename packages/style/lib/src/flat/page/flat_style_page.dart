import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:style/src/color_palette.dart';
import 'package:style/src/components/input/styled_menu_button.dart';
import 'package:style/src/components/page/styled_page.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:utils/utils.dart';

class FlatStylePageRenderer with IsTypedStyleRenderer<StyledPage> {
  @override
  Widget renderTyped(BuildContext context, StyledPage component) {
    final refreshController = useMemoized(() => RefreshController(initialRefresh: false));

    final colorPalette = context.colorPalette();

    return WillPopScope(
      onWillPop: () async {
        return await component.shouldPop?.call() ?? true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: component.title ?? component.titleText?.mapIfNonNull(StyledText.h2.strong),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            ...component.actionWidgets,
            if (component.actions.isNotEmpty) StyledMenuButton(actions: component.actions),
          ],
        ),
        backgroundColor: colorPalette.baseBackground,
        body: _refresh(
          context,
          refreshController: refreshController,
          page: component,
          child: Padding(
            padding: component.innerPadding,
            child: component.body,
          ),
        ),
      ),
    );
  }

  Widget _refresh(
    BuildContext context, {
    required RefreshController refreshController,
    required StyledPage page,
    required Widget child,
  }) {
    final colorPalette = context.colorPalette();
    if (page.onRefresh == null) {
      return child;
    }

    return SmartRefresher(
      controller: refreshController,
      header: WaterDropMaterialHeader(
        color: colorPalette.background.strong.foreground.regular,
        backgroundColor: colorPalette.background.strong,
      ),
      enablePullDown: page.onRefresh != null,
      onRefresh: page.onRefresh != null
          ? () async {
              await page.onRefresh!();
              refreshController.refreshCompleted();
            }
          : null,
      child: child,
    );
  }
}
