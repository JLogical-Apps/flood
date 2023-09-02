import 'package:pond_cli/pond_cli.dart';
import 'package:test/test.dart';

void main() {
  test('automate path definition', () async {
    final fieldProperty = FieldAutomateCommandProperty(name: 'field');
    final automatePathDefinition = AutomatePathDefinition.string('previous').property(fieldProperty).string('next');
    expect(automatePathDefinition.matches('test'), false);
    expect(automatePathDefinition.matches('previous next'), false);
    expect(automatePathDefinition.matches('previous hello next'), true);
    expect(automatePathDefinition.matches('previous "hello world" next'), true);
    expect(automatePathDefinition.matches('previous "hello next"'), false);
  });
}
