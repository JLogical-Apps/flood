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
  RuntimeType<T> register<T>(T Function() newInstanceGetter, {required String name, List<Type>? parents}) {
    final runtimeType = RuntimeType<T>(
      context: this,
      type: T,
      name: name,
      newInstanceGetter: newInstanceGetter,
      parents: parents?.map((type) => getRuntimeTypeRuntime(type)).toList() ?? [],
    );
    runtimeTypes.add(runtimeType);
    return runtimeType;
  }

  RuntimeType<T> registerAbstract<T>({required String name, List<Type>? parents}) {
    final runtimeType = RuntimeType<T>.abstract(
      context: this,
      type: T,
      name: name,
      parents: parents?.map((type) => getRuntimeTypeRuntime(type)).toList() ?? [],
    );
    runtimeTypes.add(runtimeType);
    return runtimeType;
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

  RuntimeType? getByNameOrNull(String typeName) {
    return runtimeTypes.firstWhereOrNull((runtimeType) => runtimeType.name == typeName);
  }

  RuntimeType getByName(String typeName) {
    return getByNameOrNull(typeName) ?? (throw Exception('Cannot find type with name [$typeName]'));
  }

  dynamic constructOrNull(Type type) {
    return getRuntimeTypeOrNullRuntime(type)?.createInstanceOrNull();
  }

  dynamic construct(Type type) {
    return constructOrNull(type) ?? (throw Exception('Cannot find runtime type for [$type]'));
  }

  T? constructGenericOrNull<T>() {
    return getRuntimeTypeOrNull<T>()?.createInstanceOrNull();
  }

  T constructGeneric<T>() {
    return getRuntimeType<T>().createInstance();
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

abstract class TypeContextWrapper implements TypeContext {
  TypeContext get typeContext;
}

mixin IsTypeContextWrapper implements TypeContextWrapper {
  @override
  List<RuntimeType> get runtimeTypes => typeContext.runtimeTypes;
}
