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
      create: (_) => DebugDialogContext(),
      child: HookBuilder(builder: (context) {
        final rebuilt = useState<bool>(false);
        useEffect(() {
          WidgetsBinding.instance.addPostFrameCallback((_) => rebuilt.value = true);
          return;
        });
        return Stack(
          children: [
            page,
            Positioned.fill(
              child: IgnorePointer(
                child: Material(
                    color: Colors.green.withOpacity(0.2),
                    child: Builder(
                      builder: (context) {
                        final debugDialogContext = Provider.of<DebugDialogContext>(context, listen: false);
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...debugDialogContext.data.mapToIterable((key, value) => Text(
                                    '$key: $value',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ],
                          ),
                        );
                      },
                    )),
              ),
            ),
          ],
        );
      }),
    );
  }
}
