import 'package:style/src/components/text/styled_h1.dart';
import 'package:style/src/components/text/styled_text_builder.dart';
import 'package:style/src/emphasis.dart';
import 'package:style/src/style_component.dart';

abstract class StyledText extends StyleComponent {
  final String text;
  final Emphasis emphasis;

  StyledText(this.text, {this.emphasis = Emphasis.regular});

  static StyledTextBuilder get h1 => StyledTextBuilder(builder: (text, emphasis) => StyledH1(text, emphasis: emphasis));
}
