import 'dart:async';

import 'package:utils_core/src/validation/validator.dart';

class MapValueValidator<T1, T2, E> with IsValidator<T2, E> {
  final Validator<T1, E> validator;

  final T1 Function(T2 value) mapper;

  MapValueValidator({required this.validator, required this.mapper});

  @override
  FutureOr<E?> onValidate(T2 data) {
    return validator.validate(mapper(data));
  }
}
