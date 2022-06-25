import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/src/style/export.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// A utility widget of a Row wrapped in a SingleChildScrollView with an optional Scrollbar.
class ScrollRow extends HookWidget {
  final ScrollController? controller;

  /// Whether to show a Scrollbar.
  final bool withScrollbar;

  /// The children of the column.
  final List<Widget> children;

  final CrossAxisAlignment crossAxisAlignment;

  const ScrollRow({
    Key? key,
    this.controller,
    this.withScrollbar: false,
    required this.children,
    this.crossAxisAlignment: CrossAxisAlignment.center,
  }) : super(key: key);

  const ScrollRow.withScrollbar({
    Key? key,
    this.controller,
    this.withScrollbar: true,
    required this.children,
    this.crossAxisAlignment: CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    Widget scrollView = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: controller,
      child: Row(
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      ),
      physics: BouncingScrollPhysics(),
    );
    return withScrollbar ? Scrollbar(child: scrollView) : scrollView;
  }
}
