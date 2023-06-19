import 'dart:io';

import 'package:environment/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model/model.dart';
import 'package:path/path.dart';
import 'package:pond/pond.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

class FileViewPage extends AppPage {
  late final pathProperty = field<String>(name: 'path').required();

  @override
  PathDefinition get pathDefinition => PathDefinition.string('_debug').string('file');

  @override
  List<RouteProperty> get queryProperties => [pathProperty];

  @override
  Widget build(BuildContext context) {
    final file = context.corePondContext.fileSystem.storageDirectory - pathProperty.value;
    final fileContentsModel = useFutureModel(() => file.readAsString());

    return StyledPage(
      titleText: 'File',
      body: ModelBuilder(
        model: fileContentsModel,
        builder: (String fileContents) {
          return StyledList.column.withScrollbar.centered(
            children: [
              StyledText.body(fileContents),
            ],
          );
        },
      ),
    );
  }

  @override
  AppPage copy() {
    return FileViewPage();
  }
}
