import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jlogical_utils/src/pond/modules/push_notifications/push_notification.dart';
import 'package:jlogical_utils/src/pond/modules/push_notifications/scheduled_notification.dart';

import '../../context/app_context.dart';
import 'push_notification_service.dart';

class LocalPushNotificationService extends PushNotificationService {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  bool initialized = false;

  @override
  Future<void> onLoad(AppContext context) async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
      },
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        macOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (notificationResponse) async {
        final String? payload = notificationResponse.payload;
        if (notificationResponse.payload != null) {
          debugPrint('notification payload: $payload');
        }
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    initialized = true;
  }

  @override
  Future<void> sendNotificationTo({required String to, required PushNotification notification}) async {
    if (!initialized) {
      return;
    }

    await flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          notification.title,
          notification.title,
          icon: "@mipmap/ic_launcher",
          priority: Priority.defaultPriority,
          importance: Importance.defaultImportance,
        ),
        iOS: DarwinNotificationDetails(presentAlert: true),
      ),
    );
  }

  @override
  Future<ScheduledNotification> scheduleNotification({
    required String to,
    required PushNotification notification,
    required DateTime date,
  }) async {
    if (!initialized) {
      throw Exception('Not initialized yet!');
    }

    final id = DateTime.now().millisecondsSinceEpoch;
    await flutterLocalNotificationsPlugin.schedule(
      id,
      notification.title,
      notification.body,
      date,
      NotificationDetails(
        android: AndroidNotificationDetails(
          notification.title,
          notification.title,
          icon: "@mipmap/ic_launcher",
          priority: Priority.defaultPriority,
          importance: Importance.defaultImportance,
        ),
        iOS: DarwinNotificationDetails(presentAlert: true),
      ),
      androidAllowWhileIdle: true,
    );

    return ScheduledNotification(onCancel: () => flutterLocalNotificationsPlugin.cancel(id));
  }

  @override
  Stream<String?> getDeviceTokenX() {
    return Stream.empty();
  }
}
