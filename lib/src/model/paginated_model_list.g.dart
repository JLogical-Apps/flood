// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_model_list.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PaginatedModelListStore<T> on PaginatedModelListBase<T>, Store {
  Computed<FutureValue<List<Model<T>>>>? _$modelsComputed;

  @override
  FutureValue<List<Model<T>>> get models => (_$modelsComputed ??=
          Computed<FutureValue<List<Model<T>>>>(() => super.models,
              name: 'PaginatedModelListBase.models'))
      .value;
  Computed<FutureValue<List<T>>>? _$resultsComputed;

  @override
  FutureValue<List<T>> get results =>
      (_$resultsComputed ??= Computed<FutureValue<List<T>>>(() => super.results,
              name: 'PaginatedModelListBase.results'))
          .value;

  @override
  String toString() {
    return '''
models: ${models},
results: ${results}
    ''';
  }
}
