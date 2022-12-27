import 'package:path_core/path_core.dart';
import 'package:test/test.dart';

void main() {
  test('budget route', () async {
    var route = BudgetRoute();
    expect(route.matches('/budget/asdf'), isTrue);
    expect(route.matches('/budget/'), isTrue);
    expect(route.matches('/budget'), isFalse);

    route.fromPath('/budget/asdf');
    expect(route.budgetIdProperty.value, 'asdf');
    expect(route.uri, Uri(path: '/budget/asdf'));

    route = BudgetRoute();
    expect(() => route.fromPath('/budget'), throwsA(isA<Exception>()));
  });

  test('budget route with encoded', () async {
    var route = BudgetRoute();
    route.budgetIdProperty.set('/?&%');
    expect(route.uri, Uri(path: '/budget/%2F%3F%26%25'));

    route = BudgetRoute();
    route.fromPath('/budget/%2F%3F%26%25');
    expect(route.budgetIdProperty.value, '/?&%');
  });

  test('envelope route with encoded', () async {
    var route = EnvelopeRoute();
    route.envelopeIdProperty.set('asdf');
    route.budgetIdProperty.set('http://localhost/asdf');
    expect(route.uri, Uri(path: '/envelope/asdf', queryParameters: {'budgetId': 'http://localhost/asdf'}));

    route = EnvelopeRoute();
    route.fromPath('/envelope/asdf?budgetId=http%3A%2F%2Flocalhost%2Fasdf');
    expect(route.envelopeIdProperty.value, 'asdf');
    expect(route.budgetIdProperty.value, 'http://localhost/asdf');
  });

  test('envelope route', () async {
    var route = EnvelopeRoute();
    expect(route.matches('/envelope/asdf?budgetId=123'), isTrue);
    expect(route.matches('/envelope/asdf'), isTrue);
    expect(route.matches('/envelope'), isFalse);
    expect(route.matches('/envelope?budgetId=123'), isFalse);

    route.fromPath('/envelope/envelope?budgetId=budgetId');
    expect(route.envelopeIdProperty.value, 'envelope');
    expect(route.budgetIdProperty.value, 'budgetId');
    expect(route.trayIdProperty.value, isNull);
    expect(route.uri, Uri(path: '/envelope/envelope', queryParameters: {'budgetId': 'budgetId'}));

    route = EnvelopeRoute();
    route.fromPath('/envelope/envelope?budgetId=budgetId&trayId=trayId');
    expect(route.envelopeIdProperty.value, 'envelope');
    expect(route.budgetIdProperty.value, 'budgetId');
    expect(route.trayIdProperty.value, 'trayId');
    expect(route.uri, Uri(path: '/envelope/envelope', queryParameters: {'budgetId': 'budgetId', 'trayId': 'trayId'}));

    route = EnvelopeRoute();
    expect(() => route.fromPath('/envelope/asdf'), throwsA(isA<Exception>()));
    expect(() => route.fromPath('/envelope?budgetId=123'), throwsA(isA<Exception>()));
  });
}

class BudgetRoute with IsRoute, IsPathDefinitionWrapper {
  late final budgetIdProperty = field<String>(name: ':id').required();

  @override
  PathDefinition get pathDefinition => PathDefinition.string('budget').property(budgetIdProperty);
}

class EnvelopeRoute with IsRoute, IsPathDefinitionWrapper {
  late final envelopeIdProperty = field<String>(name: ':id').required();
  late final budgetIdProperty = field<String>(name: 'budgetId').required();
  late final trayIdProperty = field<String>(name: 'trayId');

  @override
  PathDefinition get pathDefinition => PathDefinition.string('envelope').property(envelopeIdProperty);

  @override
  List<RouteProperty> get queryProperties => [budgetIdProperty, trayIdProperty];
}
