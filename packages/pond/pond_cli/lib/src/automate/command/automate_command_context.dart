import 'dart:io';

import 'package:pond_cli/src/automate/context/automate_pond_context.dart';
import 'package:pond_cli/src/automate/project/project.dart';
import 'package:pond_cli/src/automate/util/file_system/automate_file_system.dart';
import 'package:pond_cli/src/automate/util/terminal/terminal.dart';
import 'package:utils_core/utils_core.dart';

class AutomateCommandContext with IsAutomateFileSystemWrapper, IsTerminalWrapper {
  final AutomatePondContext automateContext;

  @override
  final AutomateFileSystem fileSystem;

  final Project coreProject;

  final Project appProject;

  AutomateCommandContext._({
    required this.automateContext,
    required this.coreProject,
    required this.appProject,
    required this.fileSystem,
  });

  factory AutomateCommandContext({
    required AutomatePondContext automateContext,
    Directory Function(Directory coreDirectory)? appDirectoryGetter,
    Terminal Function(Directory workingDirectory)? terminalGetter,
  }) {
    final fileSystem = AutomateFileSystem(appDirectoryGetter: appDirectoryGetter ?? (_) => throw UnimplementedError());
    terminalGetter ??= (workingDirectory) => Terminal.static.shell(workingDirectory: workingDirectory);

    final coreTerminal = terminalGetter(fileSystem.coreDirectory);
    final appTerminal = terminalGetter(fileSystem.appDirectory);

    return AutomateCommandContext._(
      automateContext: automateContext,
      fileSystem: fileSystem,
      coreProject: Project(
        terminal: coreTerminal,
        pubspecFile: fileSystem.coreDirectory - 'pubspec.yaml',
        pubGetCommand: 'dart pub get',
      ),
      appProject: Project(
        terminal: appTerminal,
        pubspecFile: fileSystem.appDirectory - 'pubspec.yaml',
        pubGetCommand: 'flutter pub get',
      ),
    );
  }

  @override
  Terminal get terminal => Terminal.static.shell().withoutRun();

  List<File> tempFiles = [];

  File get stateFile => coreDirectory / 'tool' - 'state.yaml';

  @override
  Future<File> createTempFile(String name) async {
    final file = await super.createTempFile(name);
    tempFiles.add(file);
    return file;
  }

  Future cleanup() async {
    for (final file in tempFiles) {
      file.deleteSync();
    }
  }
}
