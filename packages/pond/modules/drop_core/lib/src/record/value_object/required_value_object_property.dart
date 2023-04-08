import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';

class RequiredValueObjectProperty<T, S, L> with IsValueObjectProperty<T, S, L, RequiredValueObjectProperty<T, S, L>> {
  final ValueObjectProperty<T?, S?, L, dynamic> property;

  RequiredValueObjectProperty({required this.property});

  @override
  State modifyState(State state) {
    return property.modifyState(state);
  }

  @override
  void fromState(State state) {
    property.fromState(state);
  }

  @override
  T get value => property.value ?? (throw Exception('Required property [$property]!'));

  @override
  T? get valueOrNull => property.valueOrNull;

  @override
  void set(S value) => property.set(value ?? (throw Exception('Required property [$property]!')));

  @override
  Future<L> load(DropCoreContext context) => property.load(context);

  @override
  FutureOr<String?> onValidate(ValueObject data) {
    if (property.value == null) {
      return 'Required property [$property]!';
    }

    return null;
  }

  @override
  RequiredValueObjectProperty<T, S, L> copy() {
    return RequiredValueObjectProperty<T, S, L>(property: property.copy());
  }
}
