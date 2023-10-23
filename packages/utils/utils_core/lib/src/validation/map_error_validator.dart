import 'dart:async';

import 'package:utils_core/src/validation/validator.dart';

class MapErrorValidator<T, E, E2> with IsValidator<T, E2> {
  final Validator<T, E> validator;

  final E2 Function(E value) errorMapper;

  MapErrorValidator({required this.validator, required this.errorMapper});

  @override
  Future<E2?> onValidate(T data) async {
    final error = await validator.validate(data);
    if (error != null) {
      return errorMapper(error);
    }

    return null;
  }
}
