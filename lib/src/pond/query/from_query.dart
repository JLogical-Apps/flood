import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class FromQuery<R extends Record> extends Query<R> {
  final Type recordType;

  FromQuery()
      : recordType = R,
        super();

  List<Object?> get queryProps => [recordType];
}
