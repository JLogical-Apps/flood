import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/record/value_object/value_object_behavior.dart';

class DisplayNameValueObjectBehavior with IsValueObjectBehavior {
  final String? Function() displayNameGetter;

  DisplayNameValueObjectBehavior({required this.displayNameGetter});

  String? getDisplayName() {
    return displayNameGetter();
  }
}

extension DisplayNameValueObjectExtensions on ValueObject {
  String? getDisplayName() {
    return behaviors.whereType<DisplayNameValueObjectBehavior>().firstOrNull?.getDisplayName();
  }
}
