abstract class AutomationInteractor {
  void print(dynamic obj);

  void warning(dynamic obj);

  void error(dynamic obj);

  bool confirm(String prompt);

  Future<void> run(String command);
}
