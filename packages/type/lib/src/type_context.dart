import 'package:collection/collection.dart';
import 'package:directed_graph/directed_graph.dart';
import 'package:type/src/runtime_type.dart';
import 'package:utils_core/utils_core.dart';

abstract class TypeContext {
  List<RuntimeType> get runtimeTypes;

  factory TypeContext({List<RuntimeType>? runtimeTypes}) => _TypeContextImpl(runtimeTypes: runtimeTypes ?? []);
}

class _TypeContextImpl implements TypeContext {
  @override
  final List<RuntimeType> runtimeTypes;

  _TypeContextImpl({required this.runtimeTypes});
}

extension TypeContextExtensions on TypeContext {
  void register<T>(T Function() newInstanceGetter, {List<Type>? parents}) {
    runtimeTypes.add(RuntimeType<T>(
      context: this,
      type: T,
      newInstanceGetter: newInstanceGetter,
      parents: parents?.map((type) => getRuntimeTypeRuntime(type)).toList() ?? [],
    ));
  }

  void registerAbstract<T>({List<Type>? parents}) {
    runtimeTypes.add(RuntimeType<T>.abstract(
      context: this,
      type: T,
      parents: parents?.map((type) => getRuntimeTypeRuntime(type)).toList() ?? [],
    ));
  }

  RuntimeType? getRuntimeTypeOrNullRuntime(Type type) {
    return runtimeTypes.firstWhereOrNull((runtimeType) => runtimeType.type == type);
  }

  RuntimeType getRuntimeTypeRuntime(Type type) {
    return getRuntimeTypeOrNullRuntime(type) ?? (throw Exception('Cannot find runtime type for [$type]'));
  }

  RuntimeType<T>? getRuntimeTypeOrNull<T>() {
    return getRuntimeTypeOrNullRuntime(T) as RuntimeType<T>?;
  }

  RuntimeType<T> getRuntimeType<T>() {
    return getRuntimeTypeOrNull<T>() ?? (throw Exception('Cannot find runtime type for [$T]'));
  }

  dynamic constructOrNull(Type type) {
    return getRuntimeTypeOrNullRuntime(type)?.createInstanceOrNull();
  }

  dynamic construct(Type type) {
    return constructOrNull(type) ?? (throw Exception('Cannot find runtime type for [$type]'));
  }

  List<RuntimeType> getAncestorsOf(RuntimeType runtimeType) {
    return DirectedGraph<RuntimeType>(runtimeTypes.mapToMap((type) => MapEntry(type, type.parents.toSet())))
        .reachableVertices(runtimeType)
        .toList();
  }

  List<RuntimeType> getDescendantsOf(RuntimeType runtimeType) {
    return DirectedGraph<RuntimeType>(runtimeTypes.mapToMap((type) => MapEntry(type, getChildrenOf(type).toSet())))
        .reachableVertices(runtimeType)
        .toList();
  }

  List<RuntimeType> getChildrenOf(RuntimeType runtimeType) {
    return runtimeTypes.where((type) => type.parents.contains(runtimeType)).toList();
  }

  bool isInstanceOf(RuntimeType type, RuntimeType instanceOfCheck) {
    return type == instanceOfCheck || getAncestorsOf(type).contains(instanceOfCheck);
  }
}

mixin WithTypeContextWrapper implements TypeContext {
  TypeContext get typeContext;

  @override
  List<RuntimeType> get runtimeTypes => typeContext.runtimeTypes;
}
