enum Emphasis {
  high,
  medium,
  low,
}

extension EmphasisExtensions on Emphasis {
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
