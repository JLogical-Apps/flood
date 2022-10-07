import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jlogical_utils/src/pond/modules/push_notifications/push_notification.dart';

import '../../context/app_context.dart';
import 'push_notification_service.dart';

class LocalPushNotificationService extends PushNotificationService {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

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
  }

  @override
  Future<void> sendNotificationTo({required String to, required PushNotification notification}) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'example',
          'example',
          icon: "@mipmap/ic_launcher",
          priority: Priority.defaultPriority,
          importance: Importance.defaultImportance,
        ),
      ),
    );
  }
}
