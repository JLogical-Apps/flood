/// Represents an emphasis of a [StyledWidget].
/// A [high] emphasis means the widget should stand out more visually whereas a [low] emphasis means the widget should
/// blend in more with the background.
enum Emphasis {
  high,
  medium,
  low,
}

extension EmphasisExtensions on Emphasis {
  /// Maps an emphasis into a value based on the emphasis' value.
  T map<T>({required T high(), required T medium(), required T low()}) {
    switch (this) {
      case Emphasis.high:
        return high();
      case Emphasis.medium:
        return medium();
      case Emphasis.low:
        return low();
    }
  }
}
