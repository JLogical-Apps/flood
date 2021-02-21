// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Model<T> on ModelBase<T>, Store {
  final _$valueAtom = Atom(name: 'ModelBase.value');

  @override
  FutureValue<T> get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(FutureValue<T> value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }

  final _$ModelBaseActionController = ActionController(name: 'ModelBase');

  @override
  void set(T _value) {
    final _$actionInfo =
        _$ModelBaseActionController.startAction(name: 'ModelBase.set');
    try {
      return super.set(_value);
    } finally {
      _$ModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value}
    ''';
  }
}
