import 'package:environment/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model/model.dart';
import 'package:path/path.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:pond/pond.dart';
import 'package:port_core/port_core.dart';
import 'package:port_style/port_style.dart';
import 'package:style/style.dart';

class DeviceFilesDebugPage extends AppPage {
  @override
  PathDefinition get pathDefinition => PathDefinition.string('_debug').string('device_files');

  @override
  Widget build(BuildContext context) {
    final pathState = useState<String>('.');
    final filesModel = useFutureModel(
      () async {
        final directory = context.corePondContext.fileSystem.storageDirectory / pathState.value;
        if (!await directory.exists()) {
          return null;
        }

        final files = (await directory.listOrNull()) ?? [];
        return files..sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));
      },
      [pathState.value],
    );
    final files = filesModel.getOrNull();

    final fileContentsModel = useFutureModel(
      () async {
        final file = context.corePondContext.fileSystem.storageDirectory - pathState.value;
        if (!await file.exists()) {
          return null;
        }
        return file.readAsString();
      },
      [pathState.value],
    );
    final fileContents = fileContentsModel.getOrNull();

    return StyledPage(
      titleText: 'Device Files',
      body: StyledList.column.withScrollbar(
        children: [
          if (pathState.value != '.')
            StyledList.row(
              children: [
                StyledButton.strong(
                  labelText: 'Back',
                  iconData: Icons.arrow_back,
                  onPressed: () => pathState.value = dirname(pathState.value),
                ),
                StyledButton(
                  labelText: 'Home',
                  iconData: Icons.home,
                  onPressed: () => pathState.value = '.',
                ),
                Expanded(child: Container()),
                if (fileContents != null)
                  StyledChip(
                    backgroundColor: Colors.orange,
                    labelText: 'Edit',
                    iconData: Icons.edit,
                    onPressed: () async {
                      final port = Port.of({
                        'contents':
                            PortField.string(initialValue: fileContents).withDisplayName('Contents').multiline(),
                      }).map((data, port) => port['contents'] as String);
                      await context.showStyledDialog(StyledPortDialog(
                        port: port,
                        titleText: 'Edit File',
                        onAccept: (contents) async {
                          final file = context.corePondContext.fileSystem.storageDirectory - pathState.value;
                          await file.writeAsString(contents);
                          await fileContentsModel.load();
                        },
                      ));
                    },
                  ),
              ],
            ),
          files == null && fileContents == null
              ? StyledLoadingIndicator()
              : files != null
                  ? directoryView(
                      context,
                      path: pathState.value,
                      files: files,
                      onUpdatePath: (path) => pathState.value = path,
                    )
                  : fileView(fileContents: fileContents!),
        ],
      ),
    );
  }

  Widget fileView({required String fileContents}) {
    return StyledText.body(fileContents);
  }

  Widget directoryView(
    BuildContext context, {
    required String path,
    required List<CrossElement> files,
    required Function(String path) onUpdatePath,
  }) {
    return StyledList.column.withScrollbar.centered(
      children: [
        ...files.map<Widget>((file) {
          if (file is CrossFile) {
            return fileCard(
              file,
              onPressed: () {
                onUpdatePath(relative(
                  file.path,
                  from: context.corePondContext.fileSystem.storageDirectory.path,
                ));
              },
            );
          } else if (file is CrossDirectory) {
            return directoryCard(
              file,
              onPressed: () {
                onUpdatePath(relative(
                  file.path,
                  from: context.corePondContext.fileSystem.storageDirectory.path,
                ));
              },
            );
          }

          throw Exception('Unknown File type [$file]');
        }),
      ],
      ifEmptyText: 'No files in this directory.',
    );
  }

  @override
  AppPage copy() {
    return DeviceFilesDebugPage();
  }

  Widget fileCard(CrossFile file, {required Function() onPressed}) {
    return StyledCard(
      titleText: basename(file.path),
      leadingIcon: Icons.file_present,
      onPressed: onPressed,
    );
  }

  Widget directoryCard(CrossDirectory directory, {required Function() onPressed}) {
    return StyledCard(
      titleText: basename(directory.path),
      leadingIcon: Icons.folder,
      onPressed: onPressed,
    );
  }
}
