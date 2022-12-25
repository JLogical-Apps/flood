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

    route = BudgetRoute();
    expect(() => route.fromPath('/budget'), throwsA(isA<Exception>()));
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

    route = EnvelopeRoute();
    route.fromPath('/envelope/envelope?budgetId=budgetId&trayId=trayId');
    expect(route.envelopeIdProperty.value, 'envelope');
    expect(route.budgetIdProperty.value, 'budgetId');
    expect(route.trayIdProperty.value, 'trayId');

    route = EnvelopeRoute();
    expect(() => route.fromPath('/envelope/asdf'), throwsA(isA<Exception>()));
    expect(() => route.fromPath('/envelope?budgetId=123'), throwsA(isA<Exception>()));
  });
}

class BudgetRoute with IsRoute, IsPathDefinitionWrapper {
  late final budgetIdProperty = field<String>(name: ':id').required();

  @override
  PathDefinition get pathDefinition => PathDefinition.builder().string('budget').property(budgetIdProperty).build();
}

class EnvelopeRoute with IsRoute, IsPathDefinitionWrapper {
  late final envelopeIdProperty = field<String>(name: ':id').required();
  late final budgetIdProperty = field<String>(name: 'budgetId').required();
  late final trayIdProperty = field<String>(name: 'trayId');

  @override
  PathDefinition get pathDefinition => PathDefinition.builder().string('envelope').property(envelopeIdProperty).build();

  @override
  List<RouteProperty> get queryProperties => [budgetIdProperty, trayIdProperty];
}
