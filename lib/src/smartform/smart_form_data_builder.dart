import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/smart_form_cubit.dart';

/// Widget that builds on the data of a smart-form changing.
class SmartFormDataBuilder extends StatelessWidget {
  /// Builds a widget in response to smart-form [value].
  final Widget Function(BuildContext context, Map<String, dynamic> data) builder;

  const SmartFormDataBuilder({required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SmartFormCubit, SmartFormState>(
      builder: (context, state) {
        return builder(
          context,
          state.nameToValueMap,
        );
      },
    );
  }
}
