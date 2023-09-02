import 'package:utils_core/src/patterns/patterns.dart';
import 'package:utils_core/src/patterns/traverser/traverser.dart';

class ModifierTraverser<T> with IsTraverser<T> {
  final List<TraverserModifier<T>> modifiers;

  late final modifierResolver = Resolver.fromModifiers<TraverserModifier<T>, T>(modifiers);

  ModifierTraverser({required this.modifiers});

  @override
  Iterable<T> traverse(T object) {
    final children = modifierResolver.resolveOrNull(object)?.getNodes(object) ?? [];
    if (children.isEmpty) {
      return [object];
    }

    return children.expand((child) => traverse(child));
  }
}

abstract class TraverserModifier<T> with IsModifier<T> {
  List<T> getNodes(T object);
}
