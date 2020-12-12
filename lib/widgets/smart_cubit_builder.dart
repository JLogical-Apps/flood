import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jlogical_utils/widgets/loading_widget.dart';

/// Builds a cubit in an easy way. L1 is a loading state. L2 is a loaded state.
class SmartCubitBuilder<C extends Cubit<S>, S, L1 extends S, L2 extends S> extends StatelessWidget {
  /// The cubit to build from. If omitted, will use cubit in the hierarchy tree.
  final C cubit;

  /// The widget to show when loading.
  final Widget loadingWidget;

  /// The widget to show after it is loaded.
  final Widget Function(C cubit, L2 state) loadedWidget;

  /// The widget to show during an error.
  final Widget Function(C cubit, S state) errorWidget;

  const SmartCubitBuilder({
    this.cubit,
    @required this.loadedWidget,
    this.loadingWidget: const LoadingWidget(),
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, S>(
      cubit: cubit,
      builder: (context, state) {
        if (state is L1) {
          return loadingWidget;
        } else if (state is L2) {
          return loadedWidget(cubit ?? context.watch<C>(), state);
        } else {
          if (errorWidget == null) {
            return loadingWidget;
          }
          return errorWidget(cubit ?? context.watch<C>(), state);
        }
      },
    );
  }
}
