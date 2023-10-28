import 'package:drop_core/drop_core.dart';
import 'package:utils_core/utils_core.dart';

class AppwriteTimestampStatePersisterModifier extends StatePersisterModifier {
  @override
  Map<String, dynamic> persist(Map<String, dynamic> data) {
    var newData = data.copy();
    newData = newData.replaceWhereTraversed((key, value) => value is Timestamp, (key, value) {
      value as Timestamp;
      if (value is NowTimestamp) {
        return DateTime.now();
      } else if (value is DateTimestamp) {
        return value.time;
      }

      throw UnimplementedError();
    }).cast<String, dynamic>();
    return newData;
  }
}
