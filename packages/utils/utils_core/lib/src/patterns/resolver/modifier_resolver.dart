import 'package:collection/collection.dart';
import 'package:utils_core/src/patterns/resolver/resolver.dart';

class ModifierResolver<M extends Modifier<I>, I> implements Resolver<I, M> {
  final List<M> modifiers;

  ModifierResolver({required this.modifiers});

  @override
  M? resolveOrNull(I input) {
    return modifiers.firstWhereOrNull((modifier) => modifier.shouldModify(input));
  }
}

abstract class Modifier<I> {
  bool shouldModify(I input);
}

mixin IsModifier<I> implements Modifier<I> {}

mixin IsTypedModifier<T extends I, I> implements Modifier<I> {
  @override
  bool shouldModify(I input) => input is T;
}
