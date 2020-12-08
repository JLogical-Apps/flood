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
  /// The controller to use.
  final SmartFormController controller;

  /// Child of the smart form.
  final Widget child;

  /// Post validator after the fields have been successfully validated. Returns a map that maps the name of a field to its error, or null/empty if no errors were present.
  final PostValidator postValidator;

  /// Function to call when the form is accepted.
  final FutureOr Function(Map<String, dynamic> data) onAccept;

  const SmartForm({Key key, @required this.controller, this.onAccept, @required this.child, this.postValidator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SmartFormCubit(
        onAccept: onAccept,
        postValidator: postValidator,
      ),
      child: BlocBuilder<SmartFormCubit, SmartFormState>(
        builder: (context, state) {
          controller.setCubit(context.bloc<SmartFormCubit>());
          return LoadingOverlay(
            isLoading: state.isLoading,
            child: child,
          );
        },
      ),
    );
  }
}
