import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/modules/environment/environment_module.dart';
import 'package:jlogical_utils/src/pond/modules/push_notifications/push_notification_repository.dart';
import 'package:jlogical_utils/src/pond/modules/push_notifications/push_notification_service.dart';

import '../../context/module/app_module.dart';
import '../../modules/environment/environment.dart';
import 'firebase_push_notification_service.dart';
import 'local_push_notification_service.dart';
import 'push_notification.dart';

class PushNotificationsModule extends AppModule {
  final void Function(String? token) onDeviceTokenGenerated;
  final void Function()? onNotificationReceived;

  String? lastDeviceTokenGenerated;

  late PushNotificationService service = _getPushNotificationService();

  PushNotificationsModule({required this.onDeviceTokenGenerated, this.onNotificationReceived});

  @override
  void onRegister(AppRegistration registration) {
    registration.register<PushNotificationService>(service);
    registration.register(PushNotificationRepository());
  }

  @override
  Future<void> onLoad(AppContext context) {
    return service.onLoad(context);
  }

  PushNotificationService _getPushNotificationService() {
    switch (AppContext.global.environment) {
      case Environment.testing:
      case Environment.device:
        return LocalPushNotificationService();
      default:
        return FirebasePushNotificationService(
          onDeviceTokenGenerated: (token) {
            lastDeviceTokenGenerated = token;
            onDeviceTokenGenerated(token);
          },
          onNotificationReceived: onNotificationReceived,
        );
    }
  }

  Future<void> sendNotification({required String to, required PushNotification notification}) {
    return service.sendNotificationTo(to: to, notification: notification);
  }
}
