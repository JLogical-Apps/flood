import 'dart:io';

import 'package:dcli/dcli.dart' as dcli;
import 'package:dcli/dcli.dart';
import 'package:jlogical_utils/src/pond/automation/automation_interactor.dart';

mixin WithDcliConsoleInteractor implements ConsoleInteractor {
  Future<void> run(String command, {Directory? workingDirectory}) async {
    print('> $command');
    dcli.start(
      command,
      workingDirectory: workingDirectory?.path,
      terminal: true,
      runInShell: true,
      progress: Progress(print, stderr: printerr),
    );
    print('');
  }
}
