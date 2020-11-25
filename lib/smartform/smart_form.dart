import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jlogical_utils/smartform/cubit/smart_form_cubit.dart';
import 'package:loading_overlay/loading_overlay.dart';

/// Form that greatly helps automate forms.
/// The [children] of the SmartForm will automatically do validation, exporting of data, etc.
class SmartForm extends StatelessWidget {
  /// Children for the smart form.
  final List<Widget> children;

  /// Function to call when the form is accepted.
  final void Function(Map<String, dynamic> data) onAccept;

  const SmartForm({Key key, this.onAccept, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SmartFormCubit(),
      child: Builder(
        builder: (context) => LoadingOverlay(
          isLoading: context.watch<SmartFormCubit>().state.isLoading,
          child: Column(
            children: [
              ...children,
              ElevatedButton(
                child: Text('OK'),
                onPressed: () async {
                  SmartFormCubit smartFormCubit = context.read<SmartFormCubit>();
                  if (await smartFormCubit.validate()) {
                    onAccept?.call(smartFormCubit.state.nameToValueMap);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
