import 'package:equatable/equatable.dart';
import 'package:type/src/type_context.dart';

class RuntimeType<T> extends Equatable {
  final TypeContext context;

  final Type type;
  final String name;
  final T Function()? newInstanceGetter;
  final List<RuntimeType> parents;

  const RuntimeType({
    required this.context,
    required this.type,
    required this.name,
    required T Function() this.newInstanceGetter,
    required this.parents,
  });

  const RuntimeType.abstract({
    required this.context,
    required this.name,
    required this.type,
    required this.parents,
  }) : newInstanceGetter = null;

  bool get isAbstract => newInstanceGetter == null;

  T? createInstanceOrNull() {
    return newInstanceGetter?.call();
  }

  T createInstance() {
    return createInstanceOrNull() ?? (throw Exception('Cannot create instance of [$type] because it is abstract'));
  }

  List<T> createList() {
    return <T>[];
  }

  bool isA(RuntimeType type) {
    return context.isInstanceOf(this, type);
  }

  List<RuntimeType> getAncestors() {
    return context.getAncestorsOf(this);
  }

  List<RuntimeType> getChildren() {
    return context.getChildrenOf(this);
  }

  List<RuntimeType> getDescendants() {
    return context.getDescendantsOf(this);
  }

  @override
  List<Object?> get props => [type];
}
