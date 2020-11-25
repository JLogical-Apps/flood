import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'smart_form_cubit.freezed.dart';
part 'smart_form_state.dart';

class SmartFormCubit extends Cubit<SmartFormState> {
  SmartFormCubit({@required Map<String, dynamic> initialValues}) : super(SmartFormState(formValues: initialValues));

  /// Changes the value of the field with [name] to [value].
  void changeValue({String name, dynamic value}) {
    Map<String, dynamic> newValues = Map<String, dynamic>.of(state.formValues);
    newValues[name] = value;
    emit(state.copyWith(formValues: newValues));
  }
}
