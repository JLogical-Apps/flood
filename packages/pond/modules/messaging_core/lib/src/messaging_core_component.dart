import 'package:messaging_core/src/messaging_service.dart';
import 'package:pond_core/pond_core.dart';

class MessagingCoreComponent with IsCorePondComponentWrapper, IsMessagingServiceWrapper {
  @override
  final MessagingService messagingService;

  MessagingCoreComponent({required this.messagingService});

  @override
  CorePondComponent get corePondComponent => messagingService;
}
