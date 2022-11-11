import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';

class RequiredValueObjectProperty<T, S> implements ValueObjectProperty<T, S> {
  final ValueObjectProperty<T?, S> property;

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
}
