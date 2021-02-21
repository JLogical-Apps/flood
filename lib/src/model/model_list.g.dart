// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_list.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ModelList<T> on ModelListBase<T>, Store {
  final _$modelsAtom = Atom(name: 'ModelListBase.models');

  @override
  FutureValue<List<Model<T>>> get models {
    _$modelsAtom.reportRead();
    return super.models;
  }

  @override
  set models(FutureValue<List<Model<T>>> value) {
    _$modelsAtom.reportWrite(value, super.models, () {
      super.models = value;
    });
  }

  final _$loadAsyncAction = AsyncAction('ModelListBase.load');

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  @override
  String toString() {
    return '''
models: ${models}
    ''';
  }
}
