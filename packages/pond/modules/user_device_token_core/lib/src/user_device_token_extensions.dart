import 'package:auth_core/auth_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:messaging_core/messaging_core.dart';
import 'package:user_device_token_core/src/user_device_token_core_component.dart';
import 'package:utils_core/utils_core.dart';

extension UserDeviceTokenAuthServiceExtensions on AuthService {
  AuthService withUserDeviceTokenListener() {
    return withListener(
      onAfterLogin: (userId) async {
        final userDeviceTokenCoreComponent = context.locate<UserDeviceTokenCoreComponent>();
        final messagingComponent = context.locate<MessagingCoreComponent>();

        final deviceToken = messagingComponent.deviceToken;
        if (deviceToken == null) {
          return;
        }

        await userDeviceTokenCoreComponent.registerDevice(context.dropCoreComponent, userId, deviceToken);
      },
      onBeforeLogout: (userId) async {
        final userDeviceTokenCoreComponent = context.locate<UserDeviceTokenCoreComponent>();
        final messagingComponent = context.locate<MessagingCoreComponent>();

        final deviceToken = messagingComponent.deviceToken;
        if (deviceToken == null) {
          return;
        }

        await userDeviceTokenCoreComponent.removeDeviceToken(context.dropCoreComponent, userId, deviceToken);
      },
    );
  }
}
