import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/emphasis.dart';

class StyledTextBuilder<T extends StyledText> {
  final T Function(
    String text,
    Emphasis emphasis,
  ) builder;

  Emphasis emphasis = Emphasis.regular;

  StyledTextBuilder({required this.builder});

  StyledTextBuilder get subtle {
    emphasis = Emphasis.subtle;
    return this;
  }

  StyledTextBuilder get strong {
    emphasis = Emphasis.strong;
    return this;
  }

  T call(String text) {
    return builder(text, emphasis);
  }
}
