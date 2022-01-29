import 'dart:io';

import 'package:cli_script/cli_script.dart' as cli;
import 'package:jlogical_utils/src/pond/automation/automation_interactor.dart';
import 'package:jlogical_utils/src/utils/file_extensions.dart';

mixin WithShellAutomationInteractor implements AutomationInteractor {
  final movementKeyCodes = {
    'w': [0x1b, 0x5b, 0x41],
    's': [0x1b, 0x5b, 0x42],
  };

  Future<void> run(String command, {Directory? workingDirectory}) async {
    final script = cli.Script(command, workingDirectory: workingDirectory?.relativePath, runInShell: true);
    // final listener = _stdin.split().listen((codes) {
    //   final movementKeyCode = movementKeyCodes[String.fromCharCode(codes[0])];
    //   if (movementKeyCode != null) {
    //     movementKeyCode.forEach(script.stdin.writeCharCode);
    //   } else {
    //     codes.forEach(script.stdin.writeCharCode);
    //   }
    // });
    final listener2 = script.stdout.lines.listen(print);
    await script.done;
    // listener.cancel();
    listener2.cancel();
    await stdout.flush();
    // await cli.run(command, workingDirectory: workingDirectory?.relativePath, runInShell: true);
    // return Shell(workingDirectory: workingDirectory?.relativePath).run(command);
  }
}
