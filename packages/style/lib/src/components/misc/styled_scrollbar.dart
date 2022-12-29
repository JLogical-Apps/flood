import 'package:flutter/cupertino.dart';
import 'package:style/src/style_component.dart';

class StyledScrollbar extends StyleComponent {
  final ScrollController? controller;
  final Widget child;

  StyledScrollbar({this.controller, required this.child});
}
