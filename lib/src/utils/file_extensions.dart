import 'dart:convert';
import 'dart:io';

extension FileExtensions on File {
  /// Reads the json from a file. Returns null if an error occurred.
  Map<String, dynamic>? readJsonSync({void onError(dynamic error)?}) {
    try {
      var text = readAsStringSync();
      var _json = json.decode(text);
      return _json;
    } catch (e) {
      onError?.call(e);
      return null;
    }
  }

  /// Reads the json from a file. Returns null if an error occurred.
  Future<Map<String, dynamic>?> readJson({void onError(dynamic error)?}) async {
    try {
      var text = await readAsString();
      var _json = json.decode(text);
      return _json;
    } catch (e) {
      onError?.call(e);
      return null;
    }
  }
}
