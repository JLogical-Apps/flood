import 'package:utils_core/src/patterns/locator/locator.dart';

class ExpandLocator<T> implements Locator<T> {
  final Locator<T> locator;

  final List<T> Function(T value) expander;

  ExpandLocator({required this.locator, required this.expander});

  @override
  void register(T object) {
    expander(object).forEach(locator.register);
  }

  @override
  T? resolveOrNull(Type input) {
    return locator.resolveOrNull(input);
  }
}
