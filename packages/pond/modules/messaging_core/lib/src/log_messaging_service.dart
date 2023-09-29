import 'package:log_core/log_core.dart';
import 'package:messaging_core/src/messaging_service.dart';
import 'package:pond_core/pond_core.dart';

class LogMessagingService with IsMessagingServiceWrapper, IsCorePondComponentWrapper {
  final MessagingService source;

  LogMessagingService({required this.source});

  @override
  late final MessagingService messagingService = source.withListener(
    onBeforeSendNotificationMessage: (message, deviceToken) {
      context.log('Sending notification [$message] to [$deviceToken].');
    },
    onBeforeSendDataMessage: (message, deviceToken) {
      context.log('Sending data message [$message] to [$deviceToken].');
    },
  );

  @override
  CorePondComponent get corePondComponent => messagingService;
}
