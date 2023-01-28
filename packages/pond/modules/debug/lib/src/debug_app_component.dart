import 'package:debug/src/dialog/debug_dialog_component.dart';
import 'package:debug/src/dialog/debug_dialog_context.dart';
import 'package:debug/src/page/debug_page.dart';
import 'package:debug/src/page/debug_page_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pond/pond.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

class DebugAppComponent with IsAppPondComponent {
  final List<DebugDialogComponent> debugDialogComponents;
  final List<DebugPageComponent> debugPageComponents;

  DebugAppComponent({
    List<DebugDialogComponent>? debugDialogComponents,
    List<DebugPageComponent>? debugPageComponents,
  })  : debugDialogComponents = debugDialogComponents ?? [],
        debugPageComponents = debugPageComponents ?? [];

  @override
  Future onLoad(AppPondContext context) async {
    debugDialogComponents.addAll(context.appComponents.whereType<DebugDialogComponent>());
    debugPageComponents.addAll(context.appComponents.whereType<DebugPageComponent>());
  }

  @override
  List<AppPage> get pages => [DebugPage()];

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
                  child: StyledContainer(
                    color: Colors.green.withOpacity(0.2),
                    child: Center(
                      child: StyledList.column.withScrollbar.centered(
                        children: debugDialogComponents
                            .map((component) => component.render(context, debugDialogContext))
                            .toList(),
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
