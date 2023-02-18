import 'package:drop/drop.dart';
import 'package:drop_core/drop_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model/model.dart';

class PaginatedQueryModelBuilder<T> extends HookWidget {
  final Model<PaginatedQueryResult<T>> paginatedQueryModel;
  final Widget Function(List<T> items, Future Function()? loadNext) builder;

  const PaginatedQueryModelBuilder({super.key, required this.paginatedQueryModel, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ModelBuilder(
      model: paginatedQueryModel,
      builder: (PaginatedQueryResult<T> paginatedQueryResult) {
        return PaginatedQueryResultBuilder(
          queryResult: paginatedQueryResult,
          builder: builder,
        );
      },
    );
  }
}
