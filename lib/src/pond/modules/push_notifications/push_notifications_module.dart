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
  final void Function(String? token)? onDeviceTokenGenerated;

  String? lastDeviceTokenGenerated;

  final PushNotificationService service;

  PushNotificationsModule.environmental({
    this.onDeviceTokenGenerated,
    void Function()? onNotificationReceived,
  }) : service = _getPushNotificationService(onNotificationReceived: onNotificationReceived);

  PushNotificationsModule({required this.service, this.onDeviceTokenGenerated});

  @override
  void onRegister(AppRegistration registration) {
    registration.register<PushNotificationService>(service);
    registration.register(PushNotificationRepository());
  }

  @override
  Future<void> onLoad(AppContext context) async {
    service.getDeviceTokenX().listen((token) {
      lastDeviceTokenGenerated = token;
      onDeviceTokenGenerated?.call(token);
    });
    service.onLoad(context);
  }

  static PushNotificationService _getPushNotificationService({void Function()? onNotificationReceived}) {
    switch (AppContext.global.environment) {
      case Environment.testing:
      case Environment.device:
        return LocalPushNotificationService();
      default:
        return FirebasePushNotificationService(onNotificationReceived: onNotificationReceived);
    }
  }

  Future<void> sendNotification({required String to, required PushNotification notification}) {
    return service.sendNotificationTo(to: to, notification: notification);
  }

  Future<void> scheduleNotification({
    required String to,
    required PushNotification notification,
    required DateTime date,
  }) {
    return service.scheduleNotification(to: to, notification: notification, date: date);
  }
}
