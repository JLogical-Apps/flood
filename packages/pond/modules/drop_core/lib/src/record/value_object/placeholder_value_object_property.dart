import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';

class PlaceholderValueObjectProperty<G, S, L> with IsValueObjectPropertyWrapper<G, S, L> {
  @override
  final ValueObjectProperty<G, S, L> property;

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
  set(S value) => property.set(value);

  @override
  Future<L> load(DropCoreContext context) => property.load(context);
}
