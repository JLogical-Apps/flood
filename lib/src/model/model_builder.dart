import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../jlogical_utils.dart';

/// Builder for any async-loadable.
class ModelBuilder<V> extends HookWidget {
  /// The model to build.
  final AsyncLoadable<V> model;

  /// Builder for the loaded value.
  final Widget Function(V value) builder;

  /// Widget to display if the model is loading.
  final Widget loadingWidget;

  /// Widget to display if the model has an error.
  /// Defaults to a red centered Text.
  final Widget Function(dynamic error) errorBuilder;

  ModelBuilder({
    Key? key,
    required this.model,
    required this.builder,
    this.loadingWidget: const LoadingWidget(),
    this.errorBuilder: _defaultErrorBuilder,
  }) : super(key: key);

  ModelBuilder.scaffold({
    required this.model,
    required this.builder,
    this.loadingWidget: const LoadingScaffold(),
    this.errorBuilder: _scaffoldErrorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final maybeValue = useModel(model..ensureLoaded()).value;
    return maybeValue.when(
      initial: () => loadingWidget,
      loaded: builder,
      error: errorBuilder,
    );
  }

  static Widget _defaultErrorBuilder(dynamic error) => Center(
        child: ErrorText(
          error.toString(),
          error: error,
        ),
      );

  static Widget _scaffoldErrorBuilder(dynamic error) => ErrorScaffold(error: error);
}
