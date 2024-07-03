import 'dart:typed_data';

import 'package:asset/asset.dart';
import 'package:collection/collection.dart';
import 'package:debug/debug.dart';
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

class DeviceFilesDebugRoute with IsRoute<DeviceFilesDebugRoute> {
  @override
  PathDefinition get pathDefinition => PathDefinition.string('_debug').string('files');

  @override
  DeviceFilesDebugRoute copy() {
    return DeviceFilesDebugRoute();
  }
}

class DeviceFilesDebugPage with IsAppPageWrapper<DeviceFilesDebugRoute> {
  @override
  AppPage<DeviceFilesDebugRoute> get appPage => AppPage<DeviceFilesDebugRoute>().withDebugParent();

  @override
  Widget onBuild(BuildContext context, DeviceFilesDebugRoute route) {
    final rootDirectoryState = useState<RootDirectory>(RootDirectory.storage);
    final pathState = useState<String>('.');

    final filesModel = useFutureModel(
      () async {
        final directory = rootDirectoryState.value.getDirectory(context) / pathState.value;
        if (!await directory.exists()) {
          return null;
        }

        final files = (await directory.listOrNull()) ?? [];
        return files.sortedBy((file) => file.path.toLowerCase());
      },
      [rootDirectoryState.value, pathState.value],
    );
    final files = filesModel.getOrNull();

    final fileModel = useFutureModel(
      () async {
        final file = rootDirectoryState.value.getDirectory(context) - pathState.value;
        if (!await file.exists()) {
          return null;
        }
        return file;
      },
      [pathState.value],
    );
    final file = fileModel.getOrNull();

    final fileStringContentsModel = useFutureModel(
      () async => await file?.readAsString(),
      [file],
    );
    final fileStringContents = fileStringContentsModel.getOrNull();

    final fileRawContentsModel = useFutureModel(
      () async => await file?.read(),
      [file],
    );
    final fileRawContents = fileRawContentsModel.getOrNull();

    return StyledPage(
      titleText: 'Device Files',
      body: StyledList.column.withScrollbar(
        children: [
          if (pathState.value == '.')
            StyledList.row.centered(
              children: [
                StyledChip(
                  labelText: 'Storage',
                  onPressed: () => rootDirectoryState.value = RootDirectory.storage,
                  iconData: Icons.sd_storage,
                  emphasis: rootDirectoryState.value == RootDirectory.storage ? Emphasis.strong : Emphasis.regular,
                ),
                StyledChip(
                  labelText: 'Temporary',
                  onPressed: () => rootDirectoryState.value = RootDirectory.temp,
                  iconData: Icons.history_toggle_off,
                  emphasis: rootDirectoryState.value == RootDirectory.temp ? Emphasis.strong : Emphasis.regular,
                ),
              ],
            ),
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
                if (fileStringContents != null)
                  StyledChip(
                    backgroundColor: Colors.orange,
                    labelText: 'Edit',
                    iconData: Icons.edit,
                    onPressed: () async {
                      final port = Port.of({
                        'contents':
                            PortField.string(initialValue: fileStringContents).withDisplayName('Contents').multiline(),
                      }).map((data, port) => port['contents'] as String);
                      await context.showStyledDialog(StyledPortDialog(
                        port: port,
                        titleText: 'Edit File',
                        onAccept: (contents) async {
                          final file = rootDirectoryState.value.getDirectory(context) - pathState.value;
                          await file.writeAsString(contents);
                          await fileStringContentsModel.load();
                        },
                      ));
                    },
                  ),
                if (file != null)
                  StyledMenuButton(
                    actions: [
                      ActionItem(
                        titleText: 'Delete',
                        descriptionText: 'Delete this file.',
                        iconData: Icons.delete,
                        color: Colors.red,
                        onPerform: (context) async {
                          await context.showStyledDialog(StyledDialog.yesNo(
                            titleText: 'Confirm Delete',
                            bodyText: 'Are you sure you want to delete this file? This cannot be undone.',
                            onAccept: () async {
                              final file = rootDirectoryState.value.getDirectory(context) - pathState.value;
                              await file.delete();
                              pathState.value = dirname(pathState.value);
                            },
                          ));
                        },
                      ),
                    ],
                  )
                else if (filesModel.getOrNull() != null)
                  StyledMenuButton(
                    actions: [
                      ActionItem(
                        titleText: 'Delete',
                        descriptionText: 'Delete this directory.',
                        iconData: Icons.delete,
                        color: Colors.red,
                        onPerform: (context) async {
                          await context.showStyledDialog(StyledDialog.yesNo(
                            titleText: 'Confirm Delete',
                            bodyText: 'Are you sure you want to delete this directory? This cannot be undone.',
                            onAccept: () async {
                              final directory = rootDirectoryState.value.getDirectory(context) / pathState.value;
                              await directory.delete();
                              pathState.value = dirname(pathState.value);
                            },
                          ));
                        },
                      ),
                    ],
                  ),
              ],
            ),
          files == null && fileStringContents == null && fileRawContents == null
              ? StyledLoadingIndicator()
              : files != null
                  ? directoryView(
                      context,
                      rootDirectory: rootDirectoryState.value.getDirectory(context),
                      path: pathState.value,
                      files: files,
                      onUpdatePath: (path) => pathState.value = path,
                    )
                  : fileView(
                      fileStringContents: fileStringContents,
                      fileRawContents: fileRawContents,
                      file: file!,
                    ),
        ],
      ),
    );
  }

  Widget fileView({
    required String? fileStringContents,
    required Uint8List? fileRawContents,
    required CrossFile file,
  }) {
    if (fileStringContents != null) {
      return StyledText.body(fileStringContents);
    }
    if (fileRawContents != null) {
      final asset = Asset.upload(
        value: fileRawContents,
        path: file.path,
      );
      final assetBuilder = AssetBuilder.getAssetBuilder(asset);
      if (assetBuilder == null) {
        return StyledText.body.centered.error('File type is not recognized');
      }

      return StyledAsset(asset: asset);
    }

    throw Exception();
  }

  Widget directoryView(
    BuildContext context, {
    required CrossDirectory rootDirectory,
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
                  from: rootDirectory.path,
                ));
              },
            );
          } else if (file is CrossDirectory) {
            return directoryCard(
              file,
              onPressed: () {
                onUpdatePath(relative(
                  file.path,
                  from: rootDirectory.path,
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

enum RootDirectory {
  storage(_getStorageDirectory),
  temp(_getTempDirectory);

  final CrossDirectory Function(BuildContext context) directoryGetter;

  const RootDirectory(this.directoryGetter);

  CrossDirectory getDirectory(BuildContext context) => directoryGetter(context);
}

CrossDirectory _getStorageDirectory(BuildContext context) {
  return context.corePondContext.fileSystem.storageDirectory;
}

CrossDirectory _getTempDirectory(BuildContext context) {
  return context.corePondContext.fileSystem.tempDirectory;
}
