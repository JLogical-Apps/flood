import 'package:pond_cli/pond_cli.dart';
import 'package:test/test.dart';

void main() {
  test('automate path definition', () async {
    final fieldProperty = FieldAutomateCommandProperty(name: 'field');
    final automatePathDefinition = AutomatePathDefinition.string('previous').property(fieldProperty).string('next');
    expect(automatePathDefinition.matches(AutomatePath.parse('test')), false);
    expect(automatePathDefinition.matches(AutomatePath.parse('previous next')), false);
    expect(automatePathDefinition.matches(AutomatePath.parse('previous hello next')), true);
    expect(automatePathDefinition.matches(AutomatePath.parse('previous "hello world" next')), true);
    expect(automatePathDefinition.matches(AutomatePath.parse('previous "hello next"')), false);
  });
}
