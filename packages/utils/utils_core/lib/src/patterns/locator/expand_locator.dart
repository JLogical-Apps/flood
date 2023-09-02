import 'package:utils_core/src/patterns/locator/locator.dart';

class ExpandLocator<T> implements Locator<T> {
  final Locator<T> locator;

  final List<T> Function(T value) expander;

  ExpandLocator({required this.locator, required this.expander});

  @override
  Future onRegister(T object) async {
    for (final expanded in expander(object)) {
      await locator.register(expanded);
    }
  }

  @override
  T? resolveOrNull(Type input) {
    return locator.resolveOrNull(input);
  }
}
