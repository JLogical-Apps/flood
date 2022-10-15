abstract class CorePondComponent {}

/*
class ImageCorePondComponent extends CorePondComponent {
}

class WithDebugCorePondComponentWrapper extends CorePondComponentWrapper {
  final CorePondComponent component;

  ...

  void onRegister() {
    print('Registering: $compnoent');
    component.onRegister();
  }
}

register(ImageCorePondComponent().withDebug());

locateType(T type):
  resolver = Resolver.typed(components.map(c => registrationTypeResolver.resolve(c)));
  return resolver.resolve(type);

Resolver.typed(List components):
  return components.map(c -> (c.runtimeType, c));

class TypedResolverWrapper<T>:
  Type getDefinedType(T value)

class RuntimeTypeResolverWrapper<T>:
  Type getDefinedType(T value) => value.runtimeType

class WrapperTypeResolverWrapper<T>:
  bool shouldWrap(T value) => value is ComponentWrapper;
  Type getDefinedType(T value) => value
 */
