import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';

class RequiredValueObjectProperty<T, S, L> with IsValueObjectProperty<T, S, L> {
  final ValueObjectProperty<T?, S, L> property;

  RequiredValueObjectProperty({required this.property});

  @override
  State modifyState(State state) {
    if (property.value == null) {
      throw Exception('Required property! [$property]');
    }

    return property.modifyState(state);
  }

  @override
  void fromState(State state) {
    property.fromState(state);

    if (property.value == null) {
      throw Exception('Required property [$property]!');
    }
  }

  @override
  T get value => property.value ?? (throw Exception('Required property [$property]!'));

  @override
  void set(S value) => property.set(value ?? (throw Exception('Required property [$property]!')));

  @override
  Future<L> load(DropCoreContext context) => property.load(context);
}
