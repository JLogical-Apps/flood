import 'dart:async';

import '../../sync_validator.dart';
import '../../validator.dart';

class MappedValidator<V, M> extends Validator<V> {
  final Validator<M> parent;
  final FutureOr<M> Function(V value) valueMapper;

  MappedValidator({required this.parent, required this.valueMapper});

  @override
  Future<void> onValidate(V value) async {
    await parent.onValidate(await valueMapper(value));
  }
}

class SyncMappedValidator<V, M> extends SyncValidator<V> {
  final SyncValidator<M> parent;
  final M Function(V value) valueMapper;

  SyncMappedValidator({required this.parent, required this.valueMapper});

  @override
  void onValidateSync(V value) {
    parent.onValidate(valueMapper(value));
  }
}
