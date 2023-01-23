import 'package:debug_dialog/src/debug_dialog_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pond/pond.dart';
import 'package:provider/provider.dart';
import 'package:utils/utils.dart';

class DebugDialogAppComponent with IsAppPondComponent {
  @override
  Widget wrapPage(AppPondContext context, Widget page, AppPondPageContext pageContext) {
    if (pageContext.uri.queryParameters['_debug'] != 'true') {
      return page;
    }

    return Provider<DebugDialogContext>(
      key: UniqueKey(),
      create: (_) => DebugDialogContext(),
      child: HookBuilder(builder: (context) {
        final data = useValueStream(Provider.of<DebugDialogContext>(context, listen: false).dataX);
        return Stack(
          children: [
            page,
            Positioned.fill(
              child: IgnorePointer(
                child: Material(
                    color: Colors.green.withOpacity(0.2),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...data.mapToIterable((key, value) => Text(
                                '$key: $value',
                                style: TextStyle(color: Colors.white),
                              )),
                        ],
                      ),
                    )),
              ),
            ),
          ],
        );
      }),
    );
  }
}
