import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:log/log.dart';
import 'package:model/src/model_builder_config.dart';
import 'package:model/src/model_hooks.dart';
import 'package:model_core/model_core.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

class ModelBuilder<T> extends HookWidget {
  final Model<T> model;
  final Widget Function(T data) builder;

  final Widget? loadingIndicator;
  final Widget Function(dynamic error, StackTrace stacktrace)? errorBuilder;

  const ModelBuilder({
    super.key,
    required this.model,
    required this.builder,
    this.loadingIndicator,
    this.errorBuilder,
  });

  ModelBuilder.page({
    super.key,
    required this.model,
    required this.builder,
  })  : loadingIndicator = StyledLoadingPage(),
        errorBuilder = _styledErrorPage;

  @override
  Widget build(BuildContext context) {
    final modelBuilderConfig = Provider.of<ModelBuilderConfig?>(context, listen: false);

    final state = useModel(model);
    useEffect(
      () {
        if (state is ErrorFutureValue<T>) {
          context.logError(state.error, state.stackTrace);
        }
        return null;
      },
      [state],
    );
    if (state.isEmpty || state.isLoading) {
      return loadingIndicator ?? modelBuilderConfig?.loadingIndicator ?? StyledLoadingIndicator();
    }

    if (state is ErrorFutureValue<T>) {
      return errorBuilder?.call(state.error, state.stackTrace) ??
          modelBuilderConfig?.errorBuilder?.call(state.error, state.stackTrace) ??
          StyledText.body.error('${state.error}');
    }

    if (state is LoadedFutureValue<T>) {
      return builder(state.data);
    }

    throw Exception('Invalid Model State!');
  }

  static Widget _styledErrorPage(dynamic error, StackTrace stackTrace) {
    return StyledErrorPage(error: error, stackTrace: stackTrace);
  }
}
