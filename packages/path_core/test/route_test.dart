import 'package:path_core/path_core.dart';
import 'package:test/test.dart';

void main() {
  test('budget route', () async {
    final routeDefinition = BudgetRoute();
    expect(routeDefinition.matches('/budget/asdf'), isTrue);
    expect(routeDefinition.matches('/budget/'), isTrue);
    expect(routeDefinition.matches('/budget'), isFalse);

    final route = routeDefinition.fromPath('/budget/asdf');
    expect(route.budgetIdProperty.value, 'asdf');
    expect(route.uri, Uri(path: '/budget/asdf'));

    expect(() => routeDefinition.fromPath('/budget'), throwsA(isA<Exception>()));
  });

  test('budget route with encoded', () async {
    var route = BudgetRoute();
    route.budgetIdProperty.set('/?&%');
    expect(route.uri, Uri(path: '/budget/%2F%3F%26%25'));

    final routeDefinition = BudgetRoute();
    route = routeDefinition.fromPath('/budget/%2F%3F%26%25');
    expect(route.budgetIdProperty.value, '/?&%');
  });

  test('envelope route with encoded', () async {
    var routeDefintion = EnvelopeRoute();
    routeDefintion.envelopeIdProperty.set('asdf');
    routeDefintion.budgetIdProperty.set('http://localhost/asdf');
    expect(routeDefintion.uri, Uri(path: '/envelope/asdf', queryParameters: {'budgetId': 'http://localhost/asdf'}));

    routeDefintion = EnvelopeRoute();
    final route = routeDefintion.fromPath('/envelope/asdf?budgetId=http%3A%2F%2Flocalhost%2Fasdf');
    expect(route.envelopeIdProperty.value, 'asdf');
    expect(route.budgetIdProperty.value, 'http://localhost/asdf');
  });

  test('envelope route', () async {
    final routeDefinition = EnvelopeRoute();
    expect(routeDefinition.matches('/envelope/asdf?budgetId=123'), isTrue);
    expect(routeDefinition.matches('/envelope/asdf'), isTrue);
    expect(routeDefinition.matches('/envelope'), isFalse);
    expect(routeDefinition.matches('/envelope?budgetId=123'), isFalse);

    var route = routeDefinition.fromPath('/envelope/envelope?budgetId=budgetId');
    expect(route.envelopeIdProperty.value, 'envelope');
    expect(route.budgetIdProperty.value, 'budgetId');
    expect(route.trayIdProperty.value, isNull);
    expect(route.uri, Uri(path: '/envelope/envelope', queryParameters: {'budgetId': 'budgetId'}));

    route = routeDefinition.fromPath('/envelope/envelope?budgetId=budgetId&trayId=trayId');
    expect(route.envelopeIdProperty.value, 'envelope');
    expect(route.budgetIdProperty.value, 'budgetId');
    expect(route.trayIdProperty.value, 'trayId');
    expect(route.uri, Uri(path: '/envelope/envelope', queryParameters: {'budgetId': 'budgetId', 'trayId': 'trayId'}));

    expect(() => routeDefinition.fromPath('/envelope/asdf'), throwsA(isA<Exception>()));
    expect(() => routeDefinition.fromPath('/envelope?budgetId=123'), throwsA(isA<Exception>()));
  });
}

class BudgetRoute with IsRoute<BudgetRoute>, IsPathDefinitionWrapper {
  late final budgetIdProperty = field<String>(name: ':id').required();

  @override
  BudgetRoute copy() {
    return BudgetRoute();
  }

  @override
  PathDefinition get pathDefinition => PathDefinition.string('budget').property(budgetIdProperty);
}

class EnvelopeRoute with IsRoute<EnvelopeRoute>, IsPathDefinitionWrapper {
  late final envelopeIdProperty = field<String>(name: 'id').required();
  late final budgetIdProperty = field<String>(name: 'budgetId').required();
  late final trayIdProperty = field<String>(name: 'trayId');

  @override
  PathDefinition get pathDefinition => PathDefinition.string('envelope').property(envelopeIdProperty);

  @override
  List<RouteProperty> get queryProperties => [budgetIdProperty, trayIdProperty];

  @override
  EnvelopeRoute copy() {
    return EnvelopeRoute();
  }
}
