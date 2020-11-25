import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jlogical_utils/smartform/cubit/smart_form_cubit.dart';

/// Field in a SmartForm that handles data with type [T].
class SmartField<T> extends StatelessWidget {
  /// The name of this field. In the SmartForm.onAccept, this [name] will be mapped to this value.
  final String name;

  /// Validator for the field. Returns [null] if no errors were found.
  final String Function(T value) validator;

  /// Builder for the widget with the given [value].
  final Widget Function(T value) builder;

  const SmartField({Key key, this.name, this.validator, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return builder(context.watch<SmartFormCubit>().state.formValues[name]);
  }
}
