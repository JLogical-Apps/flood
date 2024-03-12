import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:persistence_core/persistence_core.dart';

class CsvDataSource with IsDataSourceWrapper<List<List>> {
  final DataSource<String> sourceDataSource;

  CsvDataSource({required this.sourceDataSource});

  @override
  DataSource<List<List>> get dataSource => sourceDataSource.map(
        getMapper: (text) => CsvToListConverter(
          csvSettingsDetector: FirstOccurrenceSettingsDetector(
            eols: ['\r\n', '\n'],
            textDelimiters: ['"', "'"],
          ),
        ).convert(text),
        setMapper: (csv) => ListToCsvConverter().convert(csv),
      );
}
