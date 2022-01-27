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

  void _initializeLumberdashIfNeeded() {
    if (!_isLumberdashInitialized) {
      _isLumberdashInitialized = true;
      lumberdash.putLumberdashToWork(withClients: [ColorizeLumberdash()]);
    }
  }
}
