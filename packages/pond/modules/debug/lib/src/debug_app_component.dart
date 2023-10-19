import 'package:debug/src/dialog/debug_dialog_component.dart';
import 'package:debug/src/dialog/debug_dialog_context.dart';
import 'package:debug/src/page/debug_page.dart';
import 'package:debug/src/page/debug_page_component.dart';
import 'package:flutter/material.dart' hide Route;
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
  Map<Route, AppPage> get pages => {
        DebugRoute(): DebugPage(),
      };

  @override
  Widget wrapPage(AppPondContext context, Widget page, AppPondPageContext pageContext) {
    if (pageContext.routeData.uri.queryParameters['_debug'] != 'true') {
      return page;
    }

    return Provider<DebugDialogContext>(
      key: UniqueKey(),
      create: (_) => DebugDialogContext(),
      child: HookBuilder(
        builder: (context) {
          final debugDialogContext = context.read<DebugDialogContext>();
          useValueStream(debugDialogContext.dataX);

          final showDebug = useState<bool>(false);

          return Stack(
            children: [
              page,
              if (showDebug.value)
                Positioned.fill(
                  child: StyledContainer(
                    color: context.style().colorPalette.background.strong.withOpacity(0.3),
                    child: SafeArea(
                      child: StyledList.column.withScrollbar.centered(
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          ...debugDialogComponents
                              .map((component) => component.renderDebug(context, debugDialogContext)),
                        ],
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 5,
                right: 5,
                child: SafeArea(
                  child: StyledButton.strong(
                    label: StyledIcon(showDebug.value ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      showDebug.value = !showDebug.value;
                    },
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
