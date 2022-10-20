import 'package:jlogical_utils/jlogical_utils.dart';

class PushNotificationRecord extends ValueObject {
  late final toProperty = FieldProperty<String>(name: 'to').required();
  late final titleProperty = FieldProperty<String>(name: 'title');
  late final bodyProperty = FieldProperty<String>(name: 'body');

  PushNotificationRecord();

  PushNotificationRecord.fromPushNotification({required String to, required PushNotification pushNotification}) {
    toProperty.value = to;
    titleProperty.value = pushNotification.title;
    bodyProperty.value = pushNotification.body;
  }

  @override
  List<Property> get properties =>
      super.properties +
      [
        toProperty,
        titleProperty,
        bodyProperty,
      ];
}
