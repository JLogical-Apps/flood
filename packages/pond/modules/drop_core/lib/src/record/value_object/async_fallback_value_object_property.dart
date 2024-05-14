import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class AsyncFallbackValueObjectProperty<T> with IsValueObjectPropertyWrapper<T, T, AsyncFallbackValueObjectProperty<T>> {
  @override
  final ValueObjectProperty<T, T, dynamic> property;

  final FutureOr<T> Function(DropCoreContext context) fallback;

  AsyncFallbackValueObjectProperty({required this.property, required this.fallback});

  @override
  Future<State> modifyStateForRepository(DropCoreContext context, State state) async {
    if (value == null) {
      state = state.withData(state.data.copy()..set(property.name, await fallback(context)));
    }
    return await property.modifyStateForRepository(context, state);
  }

  @override
  AsyncFallbackValueObjectProperty<T> copy() {
    return AsyncFallbackValueObjectProperty<T>(property: property.copy(), fallback: fallback);
  }
}
