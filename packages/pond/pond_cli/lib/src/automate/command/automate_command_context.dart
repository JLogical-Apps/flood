import 'dart:async';
import 'dart:io';

import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/src/automate/command/path/automate_path.dart';
import 'package:pond_cli/src/automate/context/automate_pond_context.dart';
import 'package:pond_cli/src/automate/project/project.dart';
import 'package:pond_cli/src/automate/util/file_system/automate_file_system.dart';
import 'package:pond_cli/src/automate/util/plan/plan.dart';
import 'package:pond_cli/src/automate/util/terminal/terminal.dart';
import 'package:utils_core/utils_core.dart';

class AutomateCommandContext with IsAutomateFileSystemWrapper, IsTerminalWrapper {
  final AutomatePondContext automateContext;

  final AutomatePath path;

  @override
  final AutomateFileSystem fileSystem;

  final Project coreProject;

  final Project appProject;

  AutomateCommandContext._({
    required this.automateContext,
    required this.path,
    required this.coreProject,
    required this.appProject,
    required this.fileSystem,
  });

  factory AutomateCommandContext({
    required AutomatePondContext automateContext,
    required AutomatePath path,
    Directory Function(Directory coreDirectory)? appDirectoryGetter,
    Terminal Function(Directory workingDirectory)? terminalGetter,
  }) {
    final fileSystem = AutomateFileSystem(appDirectoryGetter: appDirectoryGetter ?? (_) => throw UnimplementedError());
    terminalGetter ??= (workingDirectory) => Terminal.static.shell(workingDirectory: workingDirectory);

    final coreTerminal = terminalGetter(fileSystem.coreDirectory);
    final appTerminal = terminalGetter(fileSystem.appDirectory);

    return AutomateCommandContext._(
      automateContext: automateContext,
      path: path,
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
  Terminal get terminal => Terminal.static.shell();

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

  Future<bool> maybeConfirmAndExecutePlan(Plan plan) async {
    if (plan.items.isEmpty) {
      return true;
    }

    if (!await plan.canExecute(this)) {
      return true;
    }

    final planDescription = plan.name != null ? ': ${plan.name}' : '...';
    this.print('Preparing to execute plan$planDescription');
    await plan.preview(this);
    final shouldExecute = confirm('Would you like to execute this plan?');
    if (!shouldExecute) {
      return false;
    }

    await plan.execute(this);
    return true;
  }

  Future<void> confirmAndExecutePlan(Plan plan) async {
    final didExecute = await maybeConfirmAndExecutePlan(plan);
    if (!didExecute) {
      throw Exception('Plan rejected!');
    }
  }

  late final File stateFile = coreDirectory / 'tool' - 'state.yaml';
  late final File hiddenStateFile = coreDirectory / 'tool' - 'state.hidden.yaml';

  Future<T> _getStateOrElse<T>(String path, FutureOr<T> Function() orElse, {required File stateFile}) async {
    final stateYamlDataSource = DataSource.static.file(stateFile).mapYaml();
    final stateYaml = (await stateYamlDataSource.getOrNull()) ?? {};

    final value = stateYaml.getPathed(path);
    if (value != null) {
      return value;
    }

    final newValue = await orElse();
    stateYaml.updatePathed(path, (_) => newValue);
    await stateYamlDataSource.set(stateYaml);

    return newValue;
  }

  Future _updateState(String path, dynamic value, {required File stateFile}) async {
    final stateYamlDataSource = DataSource.static.file(stateFile).mapYaml();
    final stateYaml = (await stateYamlDataSource.getOrNull()) ?? {};

    stateYaml.updatePathed(path, (_) => value);

    await stateYamlDataSource.set(stateYaml);
  }

  Future<T> getStateOrElse<T>(String path, FutureOr<T> Function() orElse) =>
      _getStateOrElse(path, orElse, stateFile: stateFile);

  Future<T> getHiddenStateOrElse<T>(String path, FutureOr<T> Function() orElse) =>
      _getStateOrElse(path, orElse, stateFile: hiddenStateFile);

  Future updateState(String path, dynamic value) => _updateState(path, value, stateFile: stateFile);

  Future updateHiddenState(String path, dynamic value) => _updateState(path, value, stateFile: hiddenStateFile);
}
