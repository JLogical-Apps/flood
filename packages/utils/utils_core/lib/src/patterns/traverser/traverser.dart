import 'package:utils_core/src/patterns/traverser/modifier_traverser.dart';

abstract class Traverser<T> {
  Iterable<T> traverse(T object);

  factory Traverser(Iterable<T>? Function(T object) childrenGetter) => _TraverserImpl(childrenGetter: childrenGetter);

  factory Traverser.fromModifiers(List<TraverserModifier<T>> modifiers) => ModifierTraverser(modifiers: modifiers);
}

mixin IsTraverser<T> implements Traverser<T> {}

class _TraverserImpl<T> with IsTraverser<T> {
  final Iterable<T>? Function(T object) childrenGetter;

  _TraverserImpl({required this.childrenGetter});

  @override
  Iterable<T> traverse(T object) {
    final children = childrenGetter(object) ?? [];
    if (children.isEmpty) {
      return [object];
    }

    return children.expand((child) => traverse(child));
  }
}

abstract class TraverserWrapper<T> implements Traverser<T> {
  Traverser<T> get traverser;
}

mixin IsTraverserWrapper<T> implements TraverserWrapper<T> {
  @override
  Iterable<T> traverse(T object) {
    return traverser.traverse(object);
  }
}
