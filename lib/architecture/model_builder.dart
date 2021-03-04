import 'package:flutter/material.dart';
import 'package:jlogical_utils/architecture/model_state.dart';
import 'package:jlogical_utils/src/widgets/smart_cubit_builder.dart';

import '../jlogical_utils.dart';
import 'model_cubit.dart';

class ModelBuilder<C extends ModelCubit<M>, M> extends StatelessWidget {
  final C? cubit;

  final Widget? loadingWidget;
  final Widget Function(BuildContext context, C cubit, M model) builder;
  final Widget? errorWidget;

  const ModelBuilder({this.cubit, required this.builder, this.loadingWidget, this.errorWidget});

  @override
  Widget build(BuildContext context) {
    return SmartCubitBuilder<C, ModelState<M>, ModelLoadingState<M>, ModelLoadedState<M>>(
      cubit: cubit,
      loadedWidget: (cubit, state) => builder(context, cubit, state.model),
      errorWidget: (cubit, state) => errorWidget ?? loadingWidget ?? LoadingWidget(),
      loadingWidget: loadingWidget ?? LoadingWidget(),
    );
  }
}
