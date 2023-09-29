import 'package:log_core/log_core.dart';
import 'package:messaging_core/messaging_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';
import 'package:uuid/uuid.dart';

class RandomDeviceTokenMessagingService with IsCorePondComponentWrapper, IsMessagingServiceWrapper {
  @override
  final MessagingService messagingService;

  final Duration? refreshDuration;

  RandomDeviceTokenMessagingService({required this.messagingService, this.refreshDuration});

  final BehaviorSubject<FutureValue<String?>> _deviceTokenX = BehaviorSubject.seeded(FutureValue.loading());

  @override
  List<CorePondComponentBehavior> get behaviors =>
      super.behaviors +
      [
        CorePondComponentBehavior(
          onLoad: (context, _) {
            _updateDeviceToken();
            if (refreshDuration != null) {
              Stream.periodic(refreshDuration!).listen((_) => _updateDeviceToken());
            }
          },
        ),
      ];

  void _updateDeviceToken() {
    final deviceToken = Uuid().v4();
    context.log('Updating device token to [$deviceToken]');
    _deviceTokenX.value = FutureValue.loaded(deviceToken);
  }

  @override
  ValueStream<FutureValue<String?>> get deviceTokenX => _deviceTokenX;

  @override
  CorePondComponent get corePondComponent => messagingService;
}
