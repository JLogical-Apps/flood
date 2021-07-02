import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jlogical_utils/src/smartform/cubit/smart_form_cubit.dart';

/// Field in a SmartForm that handles data with type [T].
class SmartField<T> extends StatelessWidget {
  /// The name of this field. In the SmartForm.onAccept, this [name] will be mapped to this value.
  final String name;

  /// Builder for the widget with the given [value] and [error].
  final Widget Function(T value, String? error) builder;

  /// The initial value of the field.
  final T? initialValue;

  /// Validator for the field. Returns [null] if no errors were found.
  final Validator? validator;

  const SmartField({Key? key, required this.name, required this.builder, this.initialValue, this.validator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SmartFormCubit smartFormCubit = context.read<SmartFormCubit>();
    smartFormCubit.setValidator(
      name: name,
      validator: validator,
    );
    smartFormCubit.setInitialValue(
      name: name,
      value: initialValue,
    );
    return BlocBuilder<SmartFormCubit, SmartFormState>(
      buildWhen: (oldState, newState) {
        bool shouldBuild = oldState.nameToErrorMap[name] != newState.nameToErrorMap[name] || oldState.nameToValueMap[name] != newState.nameToValueMap[name];
        return shouldBuild;
      },
      builder: (context, state) {
        return builder(
          smartFormCubit.getValue(name),
          smartFormCubit.getError(name),
        );
      },
    );
  }
}
