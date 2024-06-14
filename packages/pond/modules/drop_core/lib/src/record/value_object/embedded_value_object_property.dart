import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class EmbeddedValueObjectProperty<T extends ValueObject>
    with IsValueObjectPropertyWrapper<T?, T?, EmbeddedValueObjectProperty<T>> {
  @override
  final ValueObjectProperty<T?, T?, dynamic> property;

  final void Function(T valueObject)? onInstantiate;

  EmbeddedValueObjectProperty({required this.property, this.onInstantiate});

  @override
  void fromState(DropCoreContext context, State state) {
    final stateValue = state.data[property.name];
    if (stateValue == null) {
      set(null);
    } else if (stateValue is T) {
      set(stateValue);
    } else if (stateValue is State) {
      final valueObject = (stateValue.type!.createInstance() as T)..setState(context, stateValue);
      if (onInstantiate != null) {
        onInstantiate!(valueObject);
      }

      valueObject.throwIfInvalid(null);
      set(valueObject);
    } else {
      throw Exception('Unknown ValueObject value: [$stateValue]');
    }
  }

  @override
  void set(T? value) {
    if (value != null) {
      value.entity = valueObject.entity;
    }

    property.set(value);
  }

  @override
  State modifyState(DropCoreContext context, State state) {
    return state.withData(state.data.copy()..set(name, value?.getState(context)));
  }

  @override
  Future<void> onDelete(DropCoreContext context) async {
    if (value != null) {
      await value!.onDelete(context);
    }
  }

  @override
  EmbeddedValueObjectProperty<T> copy() {
    return EmbeddedValueObjectProperty<T>(
      property: property.copy(),
      onInstantiate: onInstantiate,
    );
  }

  void Function(ValueObject valueObject)? instantiator() {
    return onInstantiate == null ? null : (valueObject) => onInstantiate!(valueObject as T);
  }

  @override
  Future<String?> onValidate(ValueObject data) async {
    return await value?.validate(null);
  }
}
