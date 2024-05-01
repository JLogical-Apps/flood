import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class AsyncFallbackValueObjectProperty<T> with IsValueObjectProperty<T, T, AsyncFallbackValueObjectProperty<T>> {
  final ValueObjectProperty<T, T, dynamic> property;

  final FutureOr<T> Function(DropCoreContext context) fallback;

  @override
  final Type getterType;

  @override
  Type get setterType => property.setterType;

  AsyncFallbackValueObjectProperty({required this.property, required this.fallback}) : getterType = T;

  @override
  State modifyState(DropCoreContext context, State state) {
    return property.modifyState(context, state);
  }

  @override
  void fromState(DropCoreContext context, State state) {
    property.fromState(context, state);
  }

  @override
  Future<State> modifyStateForRepository(DropCoreContext context, State state) async {
    if (value == null) {
      state = state.withData(state.data.copy()..set(property.name, await fallback(context)));
    }
    return await property.modifyStateForRepository(context, state);
  }

  @override
  T get value => property.value;

  @override
  T? get valueOrNull => property.valueOrNull;

  @override
  set(T value) => property.set(value);

  @override
  AsyncFallbackValueObjectProperty<T> copy() {
    return AsyncFallbackValueObjectProperty<T>(property: property.copy(), fallback: fallback);
  }

  @override
  String get name => property.name;
}
