import '../state/state.dart';

abstract class Validator {
  void validate(State value);
}