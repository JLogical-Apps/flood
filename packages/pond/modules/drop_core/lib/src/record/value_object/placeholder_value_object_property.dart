import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class PlaceholderValueObjectProperty<G, S, L>
    with IsValueObjectPropertyWrapper<G, S, L, PlaceholderValueObjectProperty<G, S, L>> {
  @override
  final ValueObjectProperty<G, S, L, dynamic> property;

  final G Function() placeholder;

  PlaceholderValueObjectProperty({required this.property, required this.placeholder});

  @override
  State modifyState(State state) {
    return property.modifyState(state);
  }

  @override
  void fromState(State state) {
    property.fromState(state);
  }

  @override
  G get value => property.value ?? placeholder();

  @override
  G? get valueOrNull => property.valueOrNull ?? guard(() => placeholder());

  @override
  set(S value) => property.set(value);

  @override
  Future<L> load(DropCoreContext context) => property.load(context);

  @override
  PlaceholderValueObjectProperty<G, S, L> copy() {
    return PlaceholderValueObjectProperty<G, S, L>(property: property.copy(), placeholder: placeholder);
  }
}
