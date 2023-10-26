class AppwriteBackendContext {
  final dynamic context;

  AppwriteBackendContext({required this.context});

  List<int> get bodyRaw => context.req.bodyRaw;

  dynamic get body => context.req.body;

  Map<String, dynamic> get headers => context.req.headers;

  String get scheme => context.req.scheme;

  String get method => context.req.method;

  String get url => context.req.url;

  String get host => context.req.host;

  int get port => context.req.port;

  String get path => context.req.path;

  String get queryString => context.req.queryString;

  void log(dynamic message) {
    context.log(message);
  }

  dynamic ok(dynamic response) {
    context.log(response);
    return context.res.send('$response');
  }

  dynamic error(dynamic response) {
    context.error(response);
    return context.res.send('$response');
  }
}
