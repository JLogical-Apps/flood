import 'dart:async';

import 'package:messaging_core/messaging_core.dart';
import 'package:pond_core/pond_core.dart';

class ListenerMessagingService with IsCorePondComponentWrapper, IsMessagingServiceWrapper {
  @override
  final MessagingService messagingService;

  final FutureOr Function(NotificationMessage message, String toDeviceToken)? onBeforeSendNotificationMessage;
  final FutureOr Function(NotificationMessage message, String toDeviceToken)? onAfterSendNotificationMessage;
  final FutureOr Function(DataMessage message, String toDeviceToken)? onBeforeSendDataMessage;
  final FutureOr Function(DataMessage message, String toDeviceToken)? onAfterSendDataMessage;

  ListenerMessagingService({
    required this.messagingService,
    this.onBeforeSendNotificationMessage,
    this.onAfterSendNotificationMessage,
    this.onBeforeSendDataMessage,
    this.onAfterSendDataMessage,
  });

  @override
  Future<void> onSendNotificationMessage(NotificationMessage message, String toDeviceToken) async {
    await onBeforeSendNotificationMessage?.call(message, toDeviceToken);
    await messagingService.onSendNotificationMessage(message, toDeviceToken);
    await onAfterSendNotificationMessage?.call(message, toDeviceToken);
  }

  @override
  Future<void> onSendDataMessage(DataMessage message, String toDeviceToken) async {
    await onBeforeSendDataMessage?.call(message, toDeviceToken);
    await messagingService.onSendDataMessage(message, toDeviceToken);
    await onAfterSendDataMessage?.call(message, toDeviceToken);
  }

  @override
  CorePondComponent get corePondComponent => messagingService;
}
