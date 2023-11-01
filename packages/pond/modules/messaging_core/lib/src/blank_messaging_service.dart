import 'package:messaging_core/messaging_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

class BlankMessagingService with IsCorePondComponent, IsMessagingService {
  @override
  Stream<DataMessage> get dataMessageX => BehaviorSubject();

  @override
  ValueStream<FutureValue<String?>> get deviceTokenX => BehaviorSubject.seeded(FutureValue.empty());

  @override
  Stream<NotificationMessage> get notificationMessageX => BehaviorSubject();

  @override
  Future<void> onSendDataMessage(DataMessage message, String toDeviceToken) async {}

  @override
  Future<void> onSendNotificationMessage(NotificationMessage message, String toDeviceToken) async {}
}
