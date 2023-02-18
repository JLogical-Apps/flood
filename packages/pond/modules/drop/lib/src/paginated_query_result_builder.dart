import 'package:drop_core/drop_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:utils/utils.dart';

class PaginatedQueryResultBuilder<T> extends HookWidget {
  final PaginatedQueryResult<T> queryResult;
  final Widget Function(List<T> items, Future Function()? loadNext) builder;

  const PaginatedQueryResultBuilder({required this.queryResult, required this.builder});

  @override
  Widget build(BuildContext context) {
    final page = useValueStream(queryResult.pageX);
    return builder(
      page.items,
      queryResult.hasNext ? () => queryResult.loadNextPage() : null,
    );
  }
}
