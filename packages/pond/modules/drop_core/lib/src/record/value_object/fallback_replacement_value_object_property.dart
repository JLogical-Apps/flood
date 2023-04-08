import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';

class FallbackReplacementValueObjectProperty<T, L>
    with IsValueObjectProperty<T, T?, L, FallbackReplacementValueObjectProperty<T, L>> {
  final ValueObjectProperty<T?, T?, L, dynamic> property;

  final T Function() fallbackReplacement;

  FallbackReplacementValueObjectProperty({required this.property, required this.fallbackReplacement});

  @override
  State modifyState(State state) {
    if (property.value == null) {
      property.set(fallbackReplacement());
    }

    return property.modifyState(state);
  }

  @override
  void fromState(State state) {
    property.fromState(state);
  }

  @override
  T get value => property.value ?? fallbackReplacement();

  @override
  set(T? value) => property.set(value);

  @override
  Future<L> load(DropCoreContext context) => property.load(context);

  @override
  FallbackReplacementValueObjectProperty<T, L> copy() {
    return FallbackReplacementValueObjectProperty<T, L>(
      property: property.copy(),
      fallbackReplacement: fallbackReplacement,
    );
  }
}
