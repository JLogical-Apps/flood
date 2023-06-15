import 'package:drop_core/src/context/core_drop_context.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class FallbackValueObjectProperty<T, S, L> with IsValueObjectProperty<T, S, L, FallbackValueObjectProperty<T, S, L>> {
  final ValueObjectProperty<T?, S, L, dynamic> property;

  final T Function() fallback;

  FallbackValueObjectProperty({required this.property, required this.fallback});

  @override
  State modifyState(CoreDropContext context, State state) {
    if (property.value == null) {
      return state.withData(state.data.copy()..set(property.name, fallback()));
    }
    return property.modifyState(context, state);
  }

  @override
  void fromState(CoreDropContext context, State state) {
    property.fromState(context, state);
  }

  @override
  T get value => property.value ?? fallback();

  @override
  T? get valueOrNull => property.valueOrNull ?? guard(() => fallback());

  @override
  set(S value) => property.set(value);

  @override
  Future<L> load(CoreDropContext context) => property.load(context);

  @override
  FallbackValueObjectProperty<T, S, L> copy() {
    return FallbackValueObjectProperty<T, S, L>(property: property.copy(), fallback: fallback);
  }

  @override
  String get name => property.name;

  @override
  List<Object?> get props => [property];
}
