import 'dart:convert';
import 'dart:io';

import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:utils_core/utils_core.dart';

enum ApiKeyRetrievalMethod {
  p8File('p8 file', _retrieveP8FileApiKey),
  encoded('encoded api key', _retrieveEncodedApiKey);

  final String displayName;
  final Future<String> Function(AutomateCommandContext context) onRetrieveEncodedApiKey;

  const ApiKeyRetrievalMethod(this.displayName, this.onRetrieveEncodedApiKey);

  Future<String> retrieveEncodedApiKey(AutomateCommandContext context) {
    return onRetrieveEncodedApiKey(context);
  }
}

Future<String> _retrieveP8FileApiKey(AutomateCommandContext context) async {
  final p8FileLocation = context.input('What is the path to your p8 file?');
  if (p8FileLocation.isBlank) {
    throw Exception('.p8 file not provided!');
  }

  final p8File = File(p8FileLocation);
  final contents = await DataSource.static.rawFile(p8File).get();
  return base64Encode(contents);
}

Future<String> _retrieveEncodedApiKey(AutomateCommandContext context) async {
  final encodedP8 = context.input('What is your base64-encoded p8 file?');
  if (encodedP8.isBlank) {
    throw Exception('Base64-encoded p8 not provided!');
  }

  return encodedP8;
}
