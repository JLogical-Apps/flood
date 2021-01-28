import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jlogical_utils/widgets/loading_widget.dart';

import 'multi_model_cubit.dart';
import 'multi_model_state.dart';

class MultiModelCubitBuilder<C extends MultiModelCubit<M>, M> extends StatelessWidget {
  /// The cubit to build. If null, uses the context to find it.
  final C cubit;

  /// The widget to show when loading.
  final Widget initialWidget;

  /// Builder for when the state is loaded.
  final Widget Function(BuildContext context, C cubit, MultiModelLoadedState<M> state) loadedBuilder;

  /// Builder for when the state is an error.
  final Widget Function(BuildContext context, C cubit, MultiModelErrorState<M> state) errorBuilder;

  MultiModelCubitBuilder({this.cubit, this.initialWidget, this.loadedBuilder, this.errorBuilder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, MultiModelState<M>>(
      cubit: cubit,
      builder: (context, state) {
        if (state is MultiModelInitialState<M>) {
          return initialWidget ?? LoadingWidget();
        } else if (state is MultiModelLoadedState<M>) {
          return loadedBuilder(context, cubit ?? context.watch<C>(), state);
        } else if (state is MultiModelErrorState<M>) {
          return errorBuilder == null ? (initialWidget ?? LoadingWidget()) : errorBuilder(context, cubit ?? context.watch<C>(), state);
        }

        return initialWidget;
      },
    );
  }
}