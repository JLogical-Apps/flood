import 'dart:io';

abstract class AutomationInteractor {
  void print(dynamic obj);

  void warning(dynamic obj);

  void error(dynamic obj);

  bool confirm(String prompt);

  String input(String prompt);

  T select<T>({
    required String prompt,
    required List<T> options,
    required String stringMapper(T value),
    T? initialValue,
  });

  List<T> multiSelect<T>({
    required String prompt,
    required List<T> options,
    required String stringMapper(T value),
  });

  Future<void> run(String command, {Directory? workingDirectory});
}
