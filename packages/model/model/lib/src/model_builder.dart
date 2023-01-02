import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model/src/model_hooks.dart';
import 'package:model_core/model_core.dart';

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
    final state = useModel(model);
    if (state.isEmpty || state.isLoading) {
      return loadingIndicator ?? CircularProgressIndicator();
    }

    if (state is ErrorModelState<T>) {
      return errorBuilder?.call(state.error, state.stacktrace) ?? Text('${state.error}\n${state.stacktrace}');
    }

    if (state is LoadedModelState<T>) {
      return builder(state.data);
    }

    throw Exception('Invalid Model State!');
  }
}
