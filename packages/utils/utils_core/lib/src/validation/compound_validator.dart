import 'dart:async';

import 'package:utils_core/src/validation/validator.dart';

class CompoundValidator<T, E> with IsValidator<T, E> {
  final List<Validator<T, E>> validators;

  CompoundValidator({required this.validators});

  @override
  FutureOr<E?> onValidate(T data) async {
    for (final validator in validators) {
      final error = await validator.validate(data);
      if (error != null) {
        return error;
      }
    }
    return null;
  }
}
