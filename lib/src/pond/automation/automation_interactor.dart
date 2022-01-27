abstract class AutomationInteractor {
  void print(dynamic obj);

  void warning(dynamic obj);

  void error(dynamic obj);

  bool confirm(String prompt);

  void run(String command);
}
