part of 'smart_form_cubit.dart';

@freezed
abstract class SmartFormState with _$SmartFormState {
  const factory SmartFormState({
    /// Maps the [name] of a field to its value.
    @required Map<String, dynamic> nameToValueMap,

    /// Maps the [name] of a field to its initial value.
    @required Map<String, dynamic> nameToInitialValueMap,

    /// Maps the [name] of a field to its error.
    @required Map<String, String> nameToErrorMap,

    /// Maps the [name] of a field to its validator.
    @required Map<String, Validator> nameToValidatorMap,
  }) = _SmartFormState;
}
