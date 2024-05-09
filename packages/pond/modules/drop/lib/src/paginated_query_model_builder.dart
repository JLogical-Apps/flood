import 'package:drop/src/paginated_query_result_builder.dart';
import 'package:drop_core/drop_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model/model.dart';
import 'package:style/style.dart';

class PaginatedQueryModelBuilder<T> extends HookWidget {
  final Model<PaginatedQueryResult<T>> paginatedQueryModel;
  final Widget Function(List<T> items, Future Function()? loadNext) builder;

  final Widget? loadingIndicator;
  final Widget Function(dynamic error, StackTrace stackTrace)? errorBuilder;

  const PaginatedQueryModelBuilder({
    super.key,
    required this.paginatedQueryModel,
    required this.builder,
    this.loadingIndicator,
    this.errorBuilder,
  });

  PaginatedQueryModelBuilder.page({
    super.key,
    required this.paginatedQueryModel,
    required this.builder,
  })  : loadingIndicator = StyledLoadingPage(),
        errorBuilder = _styledErrorPage;

  @override
  Widget build(BuildContext context) {
    return ModelBuilder(
      model: paginatedQueryModel,
      loadingIndicator: loadingIndicator,
      errorBuilder: errorBuilder,
      builder: (PaginatedQueryResult<T> paginatedQueryResult) {
        return PaginatedQueryResultBuilder(
          queryResult: paginatedQueryResult,
          builder: builder,
        );
      },
    );
  }

  static Widget _styledErrorPage(dynamic error, StackTrace stackTrace) {
    return StyledErrorPage(error: error, stackTrace: stackTrace);
  }
}
