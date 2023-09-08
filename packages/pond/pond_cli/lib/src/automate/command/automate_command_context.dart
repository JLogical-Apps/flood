import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/src/automate/context/automate_pond_context.dart';
import 'package:pond_cli/src/automate/project/project.dart';
import 'package:pond_cli/src/automate/util/file_system/automate_file_system.dart';
import 'package:pond_cli/src/automate/util/terminal/terminal.dart';
import 'package:utils_core/utils_core.dart';
import 'package:path/path.dart' as path;

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
        executableRoot: 'dart',
        directory: fileSystem.coreDirectory,
        terminal: coreTerminal,
      ),
      appProject: Project(
        executableRoot: 'flutter',
        directory: fileSystem.appDirectory,
        terminal: appTerminal,
      ),
    );
  }

  List<Project> get projects => [coreProject, appProject];

  @override
  Terminal get terminal => Terminal.static.shell().withoutRun();

  List<File> tempFiles = [];

  @override
  Future<File> createTempFile(String name) async {
    final file = await super.createTempFile(name);
    final alreadyExists = tempFiles.any((tempFile) => tempFile.path == file.path);
    if (!alreadyExists) {
      tempFiles.add(file);
    }

    return file;
  }

  Future cleanup() async {
    for (final file in tempFiles) {
      file.deleteSync();
    }
  }

  late final File stateFile = coreDirectory / 'tool' - 'state.yaml';
  late final File hiddenStateFile = coreDirectory / 'tool' - 'state.hidden.yaml';

  Future<T> _getStateOrElse<T>(String path, FutureOr<T> Function() orElse, {required File stateFile}) async {
    final stateJsonDataSource = DataSource.static.file(stateFile).mapJson();
    final stateJson = (await stateJsonDataSource.getOrNull()) ?? {};

    final value = stateJson.getPathed(path);
    if (value != null) {
      return value;
    }

    final newValue = await orElse();
    stateJson.updatePathed(path, (_) => newValue);
    await stateJsonDataSource.set(stateJson);

    return newValue;
  }

  Future _updateState(String path, dynamic value, {required File stateFile}) async {
    final stateJsonDataSource = DataSource.static.file(stateFile).mapJson();
    final stateJson = (await stateJsonDataSource.getOrNull()) ?? {};

    stateJson.updatePathed(path, (_) => value);

    await stateJsonDataSource.set(stateJson);
  }

  Future<T> getStateOrElse<T>(String path, FutureOr<T> Function() orElse) =>
      _getStateOrElse(path, orElse, stateFile: stateFile);

  Future<T> getHiddenStateOrElse<T>(String path, FutureOr<T> Function() orElse) =>
      _getStateOrElse(path, orElse, stateFile: hiddenStateFile);

  Future updateState(String path, dynamic value) => _updateState(path, value, stateFile: stateFile);

  Future updateHiddenState(String path, dynamic value) => _updateState(path, value, stateFile: hiddenStateFile);
}
