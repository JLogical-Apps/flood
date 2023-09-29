import 'dart:async';

import 'package:environment_core/environment_core.dart';
import 'package:messaging_core/src/blank_messaging_service.dart';
import 'package:messaging_core/src/data_message.dart';
import 'package:messaging_core/src/environmental_messaging_service.dart';
import 'package:messaging_core/src/listener_messaging_service.dart';
import 'package:messaging_core/src/log_messaging_service.dart';
import 'package:messaging_core/src/notification_message.dart';
import 'package:messaging_core/src/random_device_token_messaging_service.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

abstract class MessagingService with IsCorePondComponent {
  Stream<NotificationMessage> get notificationMessageX;

  Stream<DataMessage> get dataMessageX;

  ValueStream<FutureValue<String?>> get deviceTokenX;

  Future<void> onSendNotificationMessage(NotificationMessage message, String toDeviceToken);

  Future<void> onSendDataMessage(DataMessage message, String toDeviceToken);

  static final MessagingServiceStatic static = MessagingServiceStatic();
}

extension MessagingServiceExtensions on MessagingService {
  String? get deviceToken => deviceTokenX.value.getOrNull();

  Future<void> sendNotificationMessage(NotificationMessage message, String toDeviceToken) =>
      onSendNotificationMessage(message, toDeviceToken);

  Future<void> sendDataMessage(DataMessage message, String toDeviceToken) => onSendDataMessage(message, toDeviceToken);

  MessagingService withListener({
    FutureOr Function(NotificationMessage message, String toDeviceToken)? onBeforeSendNotificationMessage,
    FutureOr Function(NotificationMessage message, String toDeviceToken)? onAfterSendNotificationMessage,
    FutureOr Function(DataMessage message, String toDeviceToken)? onBeforeSendDataMessage,
    FutureOr Function(DataMessage message, String toDeviceToken)? onAfterSendDataMessage,
  }) {
    return ListenerMessagingService(
      messagingService: this,
      onBeforeSendNotificationMessage: onBeforeSendNotificationMessage,
      onAfterSendNotificationMessage: onAfterSendNotificationMessage,
      onBeforeSendDataMessage: onBeforeSendDataMessage,
      onAfterSendDataMessage: onAfterSendDataMessage,
    );
  }

  MessagingService withRandomDeviceToken({Duration? refreshDuration}) {
    return RandomDeviceTokenMessagingService(messagingService: this, refreshDuration: refreshDuration);
  }

  MessagingService log() {
    return LogMessagingService(source: this);
  }
}

class MessagingServiceStatic {
  MessagingService get blank => BlankMessagingService();

  MessagingService local({Duration? refreshDuration}) =>
      blank.withRandomDeviceToken(refreshDuration: refreshDuration).log();

  MessagingService environmental(MessagingService? Function(EnvironmentConfigCoreComponent environment) messagingServiceGetter) {
    return EnvironmentalMessagingService(messagingServiceGetter: messagingServiceGetter);
  }
}

mixin IsMessagingService implements MessagingService {}

abstract class MessagingServiceWrapper implements MessagingService {
  MessagingService get messagingService;
}

mixin IsMessagingServiceWrapper implements MessagingServiceWrapper {
  @override
  Stream<NotificationMessage> get notificationMessageX => messagingService.notificationMessageX;

  @override
  Stream<DataMessage> get dataMessageX => messagingService.dataMessageX;

  @override
  ValueStream<FutureValue<String?>> get deviceTokenX => messagingService.deviceTokenX;

  @override
  Future<void> onSendNotificationMessage(NotificationMessage message, String toDeviceToken) =>
      messagingService.sendNotificationMessage(message, toDeviceToken);

  @override
  Future<void> onSendDataMessage(DataMessage message, String toDeviceToken) =>
      messagingService.sendDataMessage(message, toDeviceToken);
}
