import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';

class RequiredValueObjectProperty<T> implements ValueObjectProperty<T> {
  final ValueObjectProperty<T?> property;

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
    if (property.value == null) {
      throw Exception('Required property [$property]!');
    }

    property.fromState(state);
  }

  @override
  T get value => property.value ?? (throw Exception('Required property [$property]!'));

  @override
  set value(T value) => property.value = value ?? (throw Exception('Required property [$property]!'));
}
