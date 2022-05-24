import 'dart:io';
import 'dart:typed_data';

import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';
import 'package:jlogical_utils/src/persistence/data_source/with_raw_file_data_source.dart';

/// Data source that points to a file.
/// The contents of the file is the persisted data.
class RawFileDataSource extends DataSource<Uint8List> with WithRawFileDataSource {
  /// The file this is pointing to.
  final File file;

  RawFileDataSource({required this.file});
}
