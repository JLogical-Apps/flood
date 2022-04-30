import 'package:collection/collection.dart';
import 'package:example/debug_view/debug_command_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/jlogical_utils.dart' as pond;

class DebugPage extends HookWidget {
  static Style style = DeltaStyle(
    primaryColor: Color(0xFFC84B31),
    accentColor: Color(0xFFECDBBA),
    backgroundColor: Color(0xFF191919),
  );

  late Model<RemoteClient> remoteClientModel = Model(loader: () {
    return RemoteHost.connect(address: loopbackAddress, port: 1237);
  });
  late Model<List<CommandStub>> commandsModel = Model(loader: () async {
    final client = await remoteClientModel.ensureLoadedAndGet();
    List jsonList = await client.run(commandName: 'list_commands');
    final stubs = jsonList
        .map((json) => pond.State.extractFrom(json))
        .map((state) => ValueObject.fromState<CommandStub>(state))
        .toList();
    return stubs;
  });

  @override
  Widget build(BuildContext context) {
    return StyleProvider(
        style: style,
        child: Builder(builder: (context) {
          return ModelBuilder.styledPage(
              model: commandsModel,
              builder: (List<CommandStub> stubs) {
                var commandsByCategory = stubs.groupListsBy((x) => x.categoryProperty.value);
                final uncategorizedCategory = commandsByCategory.remove(null) ?? [];

                const minCardWidth = 300;
                final cardsPerRow = MediaQuery.of(context).size.width ~/ minCardWidth;
                final cardWidth = MediaQuery.of(context).size.width / cardsPerRow;

                return StyledPage(
                  titleText: 'Debugger',
                  onRefresh: () async {
                    await commandsModel.load();
                  },
                  body: ScrollColumn.withScrollbar(
                    children: [
                      Wrap(
                        children: [
                          ...commandsByCategory.mapToIterable((category, commands) => SizedBox(
                                width: cardWidth,
                                child: StyledCategory.medium(
                                  headerText: category,
                                  children: _commandsList(context, commands: commands),
                                ),
                              )),
                          ..._commandsList(context, commands: uncategorizedCategory, cardWidth: cardWidth),
                        ],
                      ),
                    ],
                  ),
                );
              });
        }));
  }

  List<Widget> _commandsList(BuildContext context, {required List<CommandStub> commands, double? cardWidth}) {
    return commands
        .map((stub) => SizedBox(
              width: cardWidth,
              child: StyledContent.medium(
                headerText: stub.displayNameProperty.value,
                trailing: StyledIcon.high(Icons.chevron_right),
                onTapped: () async {
                  context.style().navigateTo(
                      context: context,
                      page: (_) => DebugCommandPage(
                            commandStub: stub,
                            onExecute: (args) async {
                              args['_source'] = stub.extraValues['_source'];

                              final client = remoteClientModel.get();
                              return await client.run(
                                commandName: stub.nameProperty.value!,
                                args: args,
                              );
                            },
                          ));
                },
              ),
            ))
        .toList();
  }
}
