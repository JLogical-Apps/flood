import 'package:flutter/widgets.dart';

import '../util.dart';

class CustomTargetContentPosition {
  CustomTargetContentPosition({
    this.top,
    this.left,
    this.bottom,
  });
  final double? top, left, bottom;
  @override
  String toString() {
    return 'CustomTargetPosition{top: $top, left: $left, bottom: $bottom}';
  }
}

enum ContentAlign { top, bottom, left, right, custom }

typedef TargetContentBuilder = Widget Function(
  BuildContext context,
  TutorialCoachMarkController controller,
);

class TargetContent {
  TargetContent({
    this.align = ContentAlign.bottom,
    this.child,
    this.customPosition,
    this.builder,
  }) : assert(!(align == ContentAlign.custom && customPosition == null));

  final ContentAlign align;
  final CustomTargetContentPosition? customPosition;
  final Widget? child;
  final TargetContentBuilder? builder;
  @override
  String toString() {
    return 'ContentTarget{align: $align, child: $child}';
  }
}
