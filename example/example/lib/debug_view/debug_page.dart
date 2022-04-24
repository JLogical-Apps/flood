import 'package:example/debug_view/debug_command_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/jlogical_utils.dart' as pond;
import 'package:jlogical_utils/remote.dart';

class DebugPage extends HookWidget {
  static Style style = DeltaStyle(
    primaryColor: Color(0xFFC84B31),
    accentColor: Color(0xFFECDBBA),
    backgroundColor: Color(0xFF191919),
  );

  late Model<RemoteClient> remoteClientModel = Model(loader: () {
    return RemoteHost.connect(address: '10.0.2.2', port: 1237);
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
                return StyledPage(
                  titleText: 'Debugger',
                  onRefresh: () async {
                    await remoteClientModel.load();
                  },
                  body: ScrollColumn.withScrollbar(
                    children: [
                      StyledCategory.medium(
                        headerText: 'Commands',
                        children: stubs
                            .map((stub) => StyledContent.medium(
                                  headerText: stub.displayNameProperty.value,
                                  onTapped: () async {
                                    context.style().navigateTo(
                                        context: context,
                                        page: (_) => DebugCommandPage(
                                              commandStub: stub,
                                              onExecute: (args) async {
                                                final client = remoteClientModel.get();
                                                return await client.run(
                                                  commandName: stub.nameProperty.value!,
                                                  args: args,
                                                );
                                              },
                                            ));
                                  },
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                );
              });
        }));
  }
}
