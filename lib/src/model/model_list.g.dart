// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_list.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ModelList<T> on ModelListBase<T>, Store {
  final _$modelsMapAtom = Atom(name: 'ModelListBase.modelsMap');

  @override
  FutureValue<Map<String, Model<T>>> get modelsMap {
    _$modelsMapAtom.reportRead();
    return super.modelsMap;
  }

  @override
  set modelsMap(FutureValue<Map<String, Model<T>>> value) {
    _$modelsMapAtom.reportWrite(value, super.modelsMap, () {
      super.modelsMap = value;
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
modelsMap: ${modelsMap}
    ''';
  }
}