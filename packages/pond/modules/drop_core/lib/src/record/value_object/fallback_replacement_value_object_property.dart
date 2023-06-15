import 'package:drop_core/src/context/core_drop_context.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class FallbackReplacementValueObjectProperty<T, L>
    with IsValueObjectProperty<T, T?, L, FallbackReplacementValueObjectProperty<T, L>> {
  final ValueObjectProperty<T?, T?, L, dynamic> property;

  final T Function() fallbackReplacement;

  FallbackReplacementValueObjectProperty({required this.property, required this.fallbackReplacement});

  @override
  State modifyState(CoreDropContext context, State state) {
    if (property.value == null) {
      property.set(fallbackReplacement());
    }

    return property.modifyState(context, state);
  }

  @override
  void fromState(CoreDropContext context, State state) {
    property.fromState(context, state);
  }

  @override
  T get value => property.value ?? fallbackReplacement();

  @override
  T? get valueOrNull => property.valueOrNull ?? guard(() => fallbackReplacement());

  @override
  set(T? value) => property.set(value);

  @override
  Future<L> load(CoreDropContext context) => property.load(context);

  @override
  FallbackReplacementValueObjectProperty<T, L> copy() {
    return FallbackReplacementValueObjectProperty<T, L>(
      property: property.copy(),
      fallbackReplacement: fallbackReplacement,
    );
  }

  @override
  String get name => property.name;

  @override
  List<Object?> get props => [property];
}
