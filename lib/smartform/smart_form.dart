import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jlogical_utils/smartform/cubit/smart_form_cubit.dart';

/// Form that greatly helps automate forms.
/// The [children] of the SmartForm will automatically do validation, exporting of data, etc.
class SmartForm extends StatelessWidget {
  /// The initial values of the fields.
  /// These are mapped by [name] to [value].
  final Map<String, dynamic> initialValues;

  /// Children for the smart form.
  final List<Widget> children;

  /// Function to call when the form is accepted.
  final void Function(Map<String, dynamic> data) onAccept;

  const SmartForm({Key key, this.initialValues, this.onAccept, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SmartFormCubit(initialValues: initialValues),
      child: Builder(
        builder: (context) => Column(
          children: [
            ...children,
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                onAccept?.call(context.read<SmartFormCubit>().state.formValues);
              },
            ),
          ],
        ),
      ),
    );
  }
}
