import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class IsNotBlankValueObjectProperty<L> with IsValueObjectProperty<String, String, L, IsNotBlankValueObjectProperty<L>> {
  final ValueObjectProperty<String?, String?, L, dynamic> property;

  IsNotBlankValueObjectProperty({required this.property});

  @override
  Type get getterType => String;

  @override
  Type get setterType => String;

  @override
  State modifyState(State state) {
    return property.modifyState(state);
  }

  @override
  void fromState(State state) {
    property.fromState(state);
  }

  @override
  FutureOr<String?> onValidate(ValueObject data) {
    if (property.value == null || property.value!.isBlank) {
      return 'Cannot be blank! [$property]';
    }

    return property.validate(data);
  }

  @override
  String get value => property.value == null || property.value!.isBlank
      ? (throw Exception('Cannot be blank! [$property]'))
      : property.value!;

  @override
  String? get valueOrNull => property.valueOrNull;

  @override
  void set(String value) => property.set(value.nullIfBlank ?? (throw Exception('Cannot be blank! [$property]')));

  @override
  Future<L> load(DropCoreContext context) => property.load(context);

  @override
  IsNotBlankValueObjectProperty<L> copy() {
    return IsNotBlankValueObjectProperty<L>(property: property.copy());
  }

  @override
  String get name => property.name;
}