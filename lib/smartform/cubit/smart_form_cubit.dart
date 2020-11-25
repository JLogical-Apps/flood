import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'smart_form_cubit.freezed.dart';
part 'smart_form_state.dart';

typedef FutureOr<T> Validator<T>(dynamic value);

class SmartFormCubit extends Cubit<SmartFormState> {
  SmartFormCubit()
      : super(SmartFormState(
          nameToValueMap: {},
          nameToErrorMap: {},
          nameToInitialValueMap: {},
          nameToValidatorMap: {},
          isLoading: false,
        ));

  /// Changes the value of the field with [name] to [value].
  void changeValue({String name, dynamic value}) {
    Map<String, dynamic> newValues = Map<String, dynamic>.of(state.nameToValueMap);
    newValues[name] = value;
    emit(state.copyWith(nameToValueMap: newValues));
  }

  /// Returns the value of the field with [name].
  dynamic getValue(String name) {
    return state.nameToValueMap[name];
  }

  /// Returns the error of the field with [name].
  String getError(String name) {
    return state.nameToErrorMap[name];
  }

  /// Validates the fields in the form and returns whether it was validated.
  Future<bool> validate() async {
    emit(state.copyWith(isLoading: true));
    Map<String, String> nameToErrorMap = {};
    bool hasError = false;
    for (var entry in state.nameToValidatorMap.entries) {
      var error = await entry.value(getValue(entry.key));
      if (error != null) {
        hasError = true;
        nameToErrorMap[entry.key] = error;
      }
    }

    emit(state.copyWith(
      nameToErrorMap: nameToErrorMap,
      isLoading: false,
    ));

    return hasError;
  }

  /// Sets the errors of the form.
  void setErrors(Map<String, String> nameToErrorMap) {
    emit(state.copyWith(nameToErrorMap: nameToErrorMap));
  }

  /// Sets the validator for the field with [name] to [validator].
  void setValidator({String name, Validator validator}) {
    if (state.nameToValidatorMap[name] == validator) {
      return;
    }

    Map<String, Validator> newValidators = Map<String, Validator>.of(state.nameToValidatorMap);
    newValidators[name] = validator;
    emit(state.copyWith(nameToValidatorMap: newValidators));
  }

  /// Sets the initial value for the field with [name] to [validator].
  void setInitialValue({String name, dynamic value}) {
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
