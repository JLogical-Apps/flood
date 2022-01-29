import 'dart:io';

import 'package:cli_script/cli_script.dart' as cli;
import 'package:jlogical_utils/src/pond/automation/automation_interactor.dart';
import 'package:jlogical_utils/src/utils/file_extensions.dart';

mixin WithShellAutomationInteractor implements AutomationInteractor {
  Future<void> run(String command, {Directory? workingDirectory}) async {
    print('> $command');
    final script = cli.Script(command, workingDirectory: workingDirectory?.relativePath, runInShell: true);
    final listeners = [script.lines.listen(print), script.stderr.lines.listen(stderr.writeln)];
    await script.done;
    listeners.forEach((listener) => listener.cancel());
    print('');
  }
}
