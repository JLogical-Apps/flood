import 'package:style/src/emphasis.dart';
import 'package:style/src/style_component.dart';

class StyledDivider extends StyleComponent {
  final Emphasis emphasis;

  StyledDivider({this.emphasis = Emphasis.regular});

  StyledDivider.subtle() : emphasis = Emphasis.subtle;

  StyledDivider.strong() : emphasis = Emphasis.strong;
}
