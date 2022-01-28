import 'package:colorize_lumberdash/colorize_lumberdash.dart';
import 'package:interact/interact.dart';
import 'package:lumberdash/lumberdash.dart' as lumberdash;

import 'automation_interactor.dart';

mixin WithConsoleAutomationOutput implements AutomationInteractor {
  bool _isLumberdashInitialized = false;

  void print(dynamic obj) {
    _initializeLumberdashIfNeeded();
    lumberdash.logMessage('$obj');
  }

  void warning(dynamic obj) {
    _initializeLumberdashIfNeeded();
    lumberdash.logWarning('$obj');
  }

  void error(dynamic obj) {
    _initializeLumberdashIfNeeded();
    lumberdash.logError('$obj', stacktrace: StackTrace.current);
  }

  bool confirm(String prompt) {
    return Confirm(prompt: prompt, waitForNewLine: true).interact();
  }

  String input(String prompt) {
    return Input(prompt: prompt).interact();
  }

  List<T> multiSelect<T>({
    required String prompt,
    required List<T> options,
    required String stringMapper(T value),
  }) {
    final selectedIndices =
        MultiSelect(prompt: prompt, options: options.map(stringMapper).toList())
            .interact();
    return selectedIndices.map((index) => options[index]).toList();
  }

  void _initializeLumberdashIfNeeded() {
    if (!_isLumberdashInitialized) {
      _isLumberdashInitialized = true;
      lumberdash.putLumberdashToWork(withClients: [ColorizeLumberdash()]);
    }
  }
}
