import 'package:debug_dialog/src/debug_dialog_component.dart';
import 'package:debug_dialog/src/debug_dialog_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pond/pond.dart';
import 'package:provider/provider.dart';
import 'package:utils/utils.dart';

class DebugDialogAppComponent with IsAppPondComponent {
  final List<DebugDialogComponent> debugDialogComponents;

  DebugDialogAppComponent({List<DebugDialogComponent>? debugDialogComponents})
      : debugDialogComponents = debugDialogComponents ?? [];

  @override
  Future onLoad(AppPondContext context) async {
    debugDialogComponents.addAll(context.appComponents.whereType<DebugDialogComponent>());
    debugDialogComponents.addAll(context.corePondContext.components.whereType<DebugDialogComponent>());
  }

  @override
  Widget wrapPage(AppPondContext context, Widget page, AppPondPageContext pageContext) {
    if (pageContext.uri.queryParameters['_debug'] != 'true') {
      return page;
    }

    return Provider<DebugDialogContext>(
      key: UniqueKey(),
      create: (_) => DebugDialogContext(),
      child: HookBuilder(
        builder: (context) {
          final debugDialogContext = Provider.of<DebugDialogContext>(context, listen: false);
          useValueStream(debugDialogContext.dataX);
          return Stack(
            children: [
              page,
              Positioned.fill(
                child: IgnorePointer(
                  child: Material(
                    color: Colors.green.withOpacity(0.2),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: debugDialogComponents
                              .map((component) => component.render(context, debugDialogContext))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
