import 'dart:async';

import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:utils_core/utils_core.dart';

class OptionsValueObjectProperty<T, S> with IsValueObjectPropertyWrapper<T, S, OptionsValueObjectProperty<T, S>> {
  @override
  final ValueObjectProperty<T, S, dynamic> property;

  final List<S> options;
  final bool canBeNull;

  OptionsValueObjectProperty({required this.property, required this.options, this.canBeNull = false});

  @override
  FutureOr<String?> onValidate(ValueObject data) async {
    final error = await property.validate(data);
    if (error != null) {
      return error;
    }

    if ((canBeNull && property.value == null) || options.contains(property.value)) {
      return null;
    }

    return '[${property.value}] is not a valid option!';
  }

  @override
  OptionsValueObjectProperty<T, S> copy() {
    return OptionsValueObjectProperty<T, S>(
      property: property.copy(),
      options: options,
      canBeNull: canBeNull,
    );
  }
}
