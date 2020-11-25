part of 'smart_form_cubit.dart';

@freezed
abstract class SmartFormState with _$SmartFormState {
  const factory SmartFormState({
    @required Map<String, dynamic> formValues,
  }) = _SmartFormState;
}
