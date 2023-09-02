# Patterns

This contains larger programming patterns.

## Resolver

A `Resolver` is an object that resolves an input to an output. For example:

````dart
final typeResolver = Resolver.byType([1, 3.14, false, 'hello world'])```
typeResolver.resolve(int); // 1
typeResolver.resolve(double); // 3.14
````

`Resolver.byType()` will resolve a `Type` into the corresponding object with that type.

Here are some other `Resolver`s:

- `Resolver.fromMap()`: Behaves very similarly to a `Map`. Resolves a key to its value.
- `Resolver.fromModifiers()`: Given a list of `Modifier`s, it will resolve an input to the first `Modifier` where `Modifier.shouldModify()` returns true.

## Locator

A `Locator` _is_ a `Resolver.byType` with some additional functionality. A `Locator` allows you `.register()` objects, and then retrieve them using `.locate<MyType>()`. This is used extensively throughout [pond_core](../../../../../pond/pond_core/README.md) to register components, then retrieve them when calling `context.find<MyComponent>()`.

## Traverser

A `Traverser` allows you to repeatedly iterate over an object to find all its "sub-objects". For example, if you have a tree, you can iterate over all the nodes to do some processing.
