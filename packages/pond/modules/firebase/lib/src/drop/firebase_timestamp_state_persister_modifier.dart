import 'package:drop_core/drop_core.dart';
import 'package:utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

class FirebaseTimestampStatePersisterModifier extends StatePersisterModifier {
  @override
  Map<String, dynamic> inflate(Map<String, dynamic> data) {
    var newData = data.copy();
    newData = newData
        .replaceWhereTraversed((key, value) => value is firestore.Timestamp,
            (key, value) => (value as firestore.Timestamp).toDate().toIso8601String())
        .cast<String, dynamic>();
    return newData;
  }

  @override
  Map<String, dynamic> persist(Map<String, dynamic> data) {
    var newData = data.copy();
    newData = newData.replaceWhereTraversed((key, value) => value is Timestamp, (key, value) {
      value as Timestamp;
      if (value is NowTimestamp) {
        return firestore.FieldValue.serverTimestamp();
      } else if (value is DateTimestamp) {
        return firestore.Timestamp.fromDate(value.time);
      }

      throw UnimplementedError();
    }).cast<String, dynamic>();
    return newData;
  }
}
