import 'dart:convert';
import 'dart:io';

import 'package:persistence_core/src/data_source.dart';

class UrlDataSource extends DataSource<HttpClientResponse> {
  final Uri url;

  UrlDataSource({required this.url});

  @override
  Stream<HttpClientResponse>? getXOrNull() {
    throw Exception('Cannot getX() a url data source!');
  }

  @override
  Future<HttpClientResponse?> getOrNull() async {
    final client = HttpClient();
    final request = await client.getUrl(url);
    final response = await request.close();

    return response;
  }

  @override
  Future<bool> exists() async {
    return true;
  }

  @override
  Future<void> set(HttpClientResponse data) async {
    throw Exception('Cannot set the data of a url data source!');
  }

  @override
  Future<void> delete() async {
    throw Exception('Cannot delete a url data source!');
  }
}

extension HttpClientResponseDataSourceExtensions on DataSource<HttpClientResponse> {
  DataSource<String> mapResponseBody() => map(
        getMapper: (response) async {
          final responseBody = await response.transform(utf8.decoder).join();
          return responseBody;
        },
        setMapper: (_) => throw Exception('Cannot set the data of a url data source!'),
      );
}
