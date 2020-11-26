import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jlogical_utils/smartform/cubit/smart_form_cubit.dart';
import 'package:jlogical_utils/smartform/smart_form_controller.dart';
import 'package:loading_overlay/loading_overlay.dart';

typedef FutureOr<Map<String, String>> PostValidator(Map<String, dynamic> data);

/// Form that greatly helps automate forms.
/// The [children] of the SmartForm will automatically do validation, exporting of data, etc.
class SmartForm extends StatelessWidget {
  /// Child of the smart form.
  final Widget Function(SmartFormController controller) child;

  /// Post validator after the fields have been successfully validated. Returns a map that maps the name of a field to its error, or null/empty if no errors were present.
  final PostValidator postValidator;

  /// Function to call when the form is accepted.
  final void Function(Map<String, dynamic> data) onAccept;

  const SmartForm({Key key, this.onAccept, this.child, this.postValidator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SmartFormCubit(
        onAccept: onAccept,
        postValidator: postValidator,
      ),
      child: BlocBuilder<SmartFormCubit, SmartFormState>(
        builder: (context, state) {
          SmartFormController controller = SmartFormController(smartFormCubit: context.bloc<SmartFormCubit>());
          return LoadingOverlay(
            isLoading: state.isLoading,
            child: child(controller),
          );
        },
      ),
    );
  }
}
