import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:persistence_core/persistence_core.dart';

class CsvDataSource with IsDataSourceWrapper<List<List>> {
  final DataSource<String> sourceDataSource;
  final bool hasHeaderRow;

  CsvDataSource({required this.sourceDataSource, required this.hasHeaderRow});

  @override
  DataSource<List<List>> get dataSource => sourceDataSource.map(
        getMapper: (text) => CsvToListConverter(
          csvSettingsDetector: FirstOccurrenceSettingsDetector(
            eols: ['\r\n', '\n'],
            textDelimiters: ['"', "'"],
          ),
        ).convert(text).skip(hasHeaderRow ? 1 : 0).toList(),
        setMapper: (csv) => ListToCsvConverter().convert(csv),
      );
}
