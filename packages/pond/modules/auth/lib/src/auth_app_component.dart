import 'package:auth_core/auth_core.dart';
import 'package:debug_dialog/debug_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model/model.dart';
import 'package:pond/pond.dart';

class AuthAppComponent with IsAppPondComponent, IsDebugDialogComponent {
  static const queriesRunField = 'auth';

  @override
  Widget render(BuildContext context, DebugDialogContext debugContext) {
    return Column(
      children: [
        Text(
          'Auth: ',
          style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white),
        ),
        HookBuilder(
          builder: (context) {
            final loggedInUserIdModel =
                useFutureModel(() => context.appPondContext.find<AuthCoreComponent>().getLoggedInUserId());
            return ModelBuilder<String?>(
              model: loggedInUserIdModel,
              builder: (loggedInUserId) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'ID: ${loggedInUserId ?? 'N/A'}',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
