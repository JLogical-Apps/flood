import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../style/export.dart';
import '../utils/export.dart';
import '../widgets/export.dart';
import 'async_loadable.dart';

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

  ModelBuilder.styled({
    Key? key,
    required this.model,
    required this.builder,
    this.loadingWidget: const StyledLoadingIndicator(),
    this.errorBuilder: _styledErrorBuilder,
  }) : super(key: key);

  ModelBuilder.styledPage({
    Key? key,
    required this.model,
    required this.builder,
    this.loadingWidget: const StyledLoadingPage(),
    Widget Function(dynamic error)? errorBuilder,
  })  : this.errorBuilder = errorBuilder ?? ((error) => _styledScaffoldErrorBuilder(error, model)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final maybeValue = useModel(model).value;
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

  static Widget _styledErrorBuilder(dynamic error) => StyledErrorText(error.toString());

  static Widget _styledScaffoldErrorBuilder<V>(dynamic error, AsyncLoadable<V> model) => StyledPage(
        body: Center(
          child: StyledErrorText(error.toString()),
        ),
        onRefresh: model.load,
      );
}
