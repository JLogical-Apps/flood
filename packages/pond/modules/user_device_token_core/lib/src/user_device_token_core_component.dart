import 'dart:async';

import 'package:auth_core/auth_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:messaging_core/messaging_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:utils_core/utils_core.dart';

class UserDeviceTokenCoreComponent with IsCorePondComponent {
  final FutureOr Function(DropCoreContext dropContext, String userId, String deviceToken) onRegisterDeviceToken;
  final FutureOr Function(DropCoreContext dropContext, String userId, String deviceToken) onRemoveDeviceToken;

  UserDeviceTokenCoreComponent({required this.onRegisterDeviceToken, required this.onRemoveDeviceToken});

  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior.dependency<AuthCoreComponent>(),
        CorePondComponentBehavior.dependency<DropCoreComponent>(),
        CorePondComponentBehavior.dependency<MessagingCoreComponent>(),
        CorePondComponentBehavior(
          onLoad: (context, _) async {
            final authComponent = context.locate<AuthCoreComponent>();
            final dropComponent = context.locate<DropCoreComponent>();
            final messagingComponent = context.locate<MessagingCoreComponent>();

            String? lastDeviceToken;
            messagingComponent.deviceTokenX.whereLoaded().listen((newDeviceToken) {
              final userId = authComponent.loggedInUserId;
              final tokenChanged = lastDeviceToken != newDeviceToken;

              if (tokenChanged && userId != null) {
                if (lastDeviceToken != null) {
                  onRemoveDeviceToken(dropComponent, userId, lastDeviceToken!);
                }
                if (newDeviceToken != null) {
                  onRegisterDeviceToken(dropComponent, userId, newDeviceToken);
                }
              }

              lastDeviceToken = newDeviceToken;
            });
          },
        ),
      ];

  Future registerDevice(DropCoreContext dropContext, String userId, String deviceToken) async =>
      await onRegisterDeviceToken(dropContext, userId, deviceToken);

  Future removeDeviceToken(DropCoreContext dropContext, String userId, String deviceToken) async =>
      await onRemoveDeviceToken(dropContext, userId, deviceToken);
}
