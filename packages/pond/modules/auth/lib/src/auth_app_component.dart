import 'package:auth_core/auth_core.dart';
import 'package:debug/debug.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pond/pond.dart';
import 'package:style/style.dart';

class AuthAppComponent with IsAppPondComponent, IsDebugDialogComponent {
  static const queriesRunField = 'auth';

  @override
  Widget renderDebug(BuildContext context, DebugDialogContext debugContext) {
    return HookBuilder(builder: (context) {
      return StyledCard(
        titleText: 'Auth',
        bodyText: 'ID: ${context.appPondContext.find<AuthCoreComponent>().loggedInUserId ?? 'N/A'}',
      );
    });
  }
}
