import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jlogical_utils/smartform/cubit/smart_form_cubit.dart';
import 'package:jlogical_utils/smartform/smart_form_controller.dart';
import 'package:loading_overlay/loading_overlay.dart';

/// Form that greatly helps automate forms.
/// The [children] of the SmartForm will automatically do validation, exporting of data, etc.
class SmartForm extends StatelessWidget {
  /// The controller for the smart form.
  final SmartFormController controller;

  /// Children for the smart form.
  final List<Widget> children;

  /// Function to call when the form is accepted.
  final void Function(Map<String, dynamic> data) onAccept;

  const SmartForm({Key key, this.controller, this.onAccept, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SmartFormCubit(onAccept: onAccept),
      child: BlocBuilder<SmartFormCubit, SmartFormState>(
        builder: (context, state) {
          controller?.setCubit(BlocProvider.of<SmartFormCubit>(context));
          return LoadingOverlay(
            isLoading: state.isLoading,
            child: Column(
              children: children,
            ),
          );
        },
      ),
    );
  }
}
