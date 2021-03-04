import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jlogical_utils/smartform/smart_form.dart';

part 'smart_form_cubit.freezed.dart';
part 'smart_form_state.dart';

typedef FutureOr<String?> Validator<T>(T value);

class SmartFormCubit extends Cubit<SmartFormState> {
  /// Function to call when the input is accepted.
  final FutureOr Function(Map<String, dynamic> data)? onAccept;

  /// The validator to run after all the fields have validated themselves.
  final PostValidator? postValidator;

  SmartFormCubit({required this.onAccept, required this.postValidator})
      : super(SmartFormState(
          nameToValueMap: {},
          nameToErrorMap: {},
          nameToInitialValueMap: {},
          nameToValidatorMap: {},
          isLoading: false,
        ));

  /// Changes the value of the field with [name] to [value].
  void changeValue({required String name, required dynamic value}) {
    Map<String, dynamic> newValues = Map<String, dynamic>.of(state.nameToValueMap);
    newValues[name] = value;
    emit(state.copyWith(nameToValueMap: newValues));
  }

  /// Returns the value of the field with [name].
  dynamic? getValue(String name) {
    return state.nameToValueMap[name];
  }

  /// Returns the error of the field with [name].
  String? getError(String name) {
    return state.nameToErrorMap[name];
  }

  /// Validates the fields in the form and returns whether it was validated.
  Future<bool> validate() async {
    emit(state.copyWith(isLoading: true));
    Map<String, String> nameToErrorMap = {};
    bool hasError = false;
    for (var entry in state.nameToValidatorMap.entries) {
      var validator = entry.value;
      if (validator != null) {
        var error = await validator(getValue(entry.key));
        if (error != null) {
          hasError = true;
          nameToErrorMap[entry.key] = error;
        }
      }
    }

    if (hasError) {
      emit(state.copyWith(
        nameToErrorMap: nameToErrorMap,
        isLoading: false,
      ));

      return false;
    }

    if (postValidator != null) nameToErrorMap = await postValidator!.call(state.nameToValueMap);

    hasError = nameToErrorMap.isNotEmpty;

    if (!hasError) {
      await onAccept?.call(state.nameToValueMap);
    }

    emit(state.copyWith(
      nameToErrorMap: nameToErrorMap,
      isLoading: false,
    ));

    return !hasError;
  }

  /// Sets the errors of the form.
  void setErrors(Map<String, String> nameToErrorMap) {
    emit(state.copyWith(nameToErrorMap: nameToErrorMap));
  }

  /// Sets the validator for the field with [name] to [validator].
  void setValidator({required String name, required Validator? validator}) {
    if (state.nameToValidatorMap[name] == validator) {
      return;
    }

    Map<String, Validator?> newValidators = Map<String, Validator?>.of(state.nameToValidatorMap);
    newValidators[name] = validator;
    emit(state.copyWith(nameToValidatorMap: newValidators));
  }

  /// Sets the initial value for the field with [name] to [validator].
  void setInitialValue({required String name, required dynamic value}) {
    if (state.nameToInitialValueMap.containsKey(name)) {
      return;
    }

    Map<String, dynamic> newValues = Map<String, dynamic>.of(state.nameToValueMap);
    newValues[name] = value;

    Map<String, dynamic> newInitialValues = Map<String, dynamic>.of(state.nameToInitialValueMap);
    newInitialValues[name] = value;

    emit(state.copyWith(nameToValueMap: newValues, nameToInitialValueMap: newInitialValues));
  }
}
