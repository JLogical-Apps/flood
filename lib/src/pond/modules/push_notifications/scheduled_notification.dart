import 'dart:async';

class ScheduledNotification {
  final FutureOr Function() onCancel;

  const ScheduledNotification({required this.onCancel});

  Future<void> cancel() async {
    await onCancel();
  }
}
