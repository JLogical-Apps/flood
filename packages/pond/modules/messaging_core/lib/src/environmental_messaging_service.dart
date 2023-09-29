import 'package:environment_core/environment_core.dart';
import 'package:messaging_core/messaging_core.dart';
import 'package:pond_core/pond_core.dart';

class EnvironmentalMessagingService with IsCorePondComponentWrapper, IsMessagingServiceWrapper {
  final MessagingService? Function(EnvironmentConfigCoreComponent environment) messagingServiceGetter;

  EnvironmentalMessagingService({required this.messagingServiceGetter});

  @override
  late final MessagingService messagingService =
      messagingServiceGetter(context.environmentCoreComponent) ?? MessagingService.static.local();

  @override
  CorePondComponent get corePondComponent => messagingService;
}
