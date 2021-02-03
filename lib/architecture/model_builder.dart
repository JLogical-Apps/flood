import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jlogical_utils/architecture/model_state.dart';
import 'package:jlogical_utils/widgets/loading_widget.dart';
import 'package:jlogical_utils/widgets/smart_cubit_builder.dart';

import 'model_cubit.dart';

class ModelBuilder<C extends ModelCubit<M>, M> extends StatelessWidget {
  final C cubit;

  final Widget loadingWidget;
  final Widget Function(BuildContext context, C cubit, M model) builder;
  final Widget errorWidget;

  const ModelBuilder({this.cubit, @required this.builder, this.loadingWidget, this.errorWidget});

  @override
  Widget build(BuildContext context) {
    return SmartCubitBuilder<C, ModelState<M>, ModelLoadingState<M>, ModelLoadedState<M>>(
      cubit: cubit,
      loadedWidget: (cubit, state) => builder(context, cubit ?? context.read<C>(), state.model),
      errorWidget: (cubit, state) => errorWidget ?? loadingWidget ?? LoadingWidget(),
      loadingWidget: loadingWidget ?? LoadingWidget(),
    );
  }
}
