import 'package:auth_core/auth_core.dart';
import 'package:debug/debug.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model/model.dart';
import 'package:pond/pond.dart';
import 'package:style/style.dart';

class AuthAppComponent with IsAppPondComponent, IsDebugDialogComponent {
  static const queriesRunField = 'auth';

  @override
  Widget render(BuildContext context, DebugDialogContext debugContext) {
    return Column(
      children: [
        StyledText.h6('Auth: '),
        HookBuilder(
          builder: (context) {
            final loggedInUserIdModel =
                useFutureModel(() => context.appPondContext.find<AuthCoreComponent>().getLoggedInUserId());
            return ModelBuilder<String?>(
              model: loggedInUserIdModel,
              builder: (loggedInUserId) {
                return StyledText.body('ID: ${loggedInUserId ?? 'N/A'}');
              },
            );
          },
        ),
      ],
    );
  }
}
