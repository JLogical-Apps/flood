import 'package:collection/collection.dart';
import 'package:utils_core/src/patterns/resolver/resolver.dart';

class WrapperResolver<W extends Wrapper<I>, I> implements Resolver<I, W> {
  final List<W> wrappers;

  WrapperResolver({required this.wrappers});

  @override
  W? resolveOrNull(I input) {
    return wrappers.firstWhereOrNull((wrapper) => wrapper.shouldWrap(input));
  }
}

abstract class Wrapper<I> {
  bool shouldWrap(I input);
}
