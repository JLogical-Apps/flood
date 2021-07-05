import 'package:flutter/material.dart';

/// A utility widget of a Column wrapped in a SingleChildScrollView with an optional Scrollbar.
class ScrollColumn extends StatelessWidget {
  /// Whether to show a Scrollbar.
  final bool withScrollbar;

  /// The children of the column.
  final List<Widget> children;

  const ScrollColumn({Key? key, this.withScrollbar: false, required this.children}) : super(key: key);

  const ScrollColumn.withScrollbar({Key? key, required List<Widget> children}) : this(key: key, withScrollbar: true, children: children);

  @override
  Widget build(BuildContext context) {
    var scrollView = SingleChildScrollView(
      child: Column(children: children),
    );
    return withScrollbar ? Scrollbar(child: scrollView) : scrollView;
  }
}
