import 'package:drop/drop.dart';
import 'package:drop/src/debug/drop_debug_repository_page.dart';
import 'package:flutter/material.dart';
import 'package:pond/pond.dart';
import 'package:style/style.dart';

class DropDebugPage extends AppPage<DropDebugRoute> {
  @override
  Widget onBuild(BuildContext context, DropDebugRoute route) {
    final repositories = context.dropCoreComponent.repositories.toList();

    return StyledPage(
      titleText: 'Drop',
      body: StyledList.column.scrollable.withScrollbar(
        children: repositories.map((repository) {
          return StyledCard(
            titleText: '${repository.runtimeType}',
            bodyText: repository.handledTypes.map((type) => type.name).join(', '),
            onPressed: () {
              context.push(DropDebugRepositoryRoute()..hashProperty.set(repository.hashCode));
            },
          );
        }).toList(),
      ),
    );
  }
}

class DropDebugRoute with IsRoute<DropDebugRoute> {
  @override
  DropDebugRoute copy() {
    return DropDebugRoute();
  }

  @override
  PathDefinition get pathDefinition => PathDefinition.string('_debug').string('drop');
}
