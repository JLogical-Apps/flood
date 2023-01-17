import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model/src/model_builder_config.dart';
import 'package:model/src/model_hooks.dart';
import 'package:model_core/model_core.dart';
import 'package:provider/provider.dart';
import 'package:utils_core/utils_core.dart';

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

  @override
  Widget build(BuildContext context) {
    final modelBuilderConfig = Provider.of<ModelBuilderConfig?>(context, listen: false);

    final state = useModel(model);
    if (state.isEmpty || state.isLoading) {
      return loadingIndicator ?? modelBuilderConfig?.loadingIndicator ?? CircularProgressIndicator();
    }

    if (state is ErrorFutureValue<T>) {
      return errorBuilder?.call(state.error, state.stackTrace) ??
          modelBuilderConfig?.errorBuilder?.call(state.error, state.stackTrace) ??
          Text('${state.error}\n${state.stackTrace}');
    }

    if (state is LoadedFutureValue<T>) {
      return builder(state.data);
    }

    throw Exception('Invalid Model State!');
  }
}
