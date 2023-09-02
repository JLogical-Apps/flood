import 'package:pond_cli/pond_cli.dart';
import 'package:test/test.dart';

void main() {
  test('automate path parsing', () async {
    expect(AutomatePath.parse('echo Hi'), AutomatePath(segments: ['echo', 'Hi']));
    expect(AutomatePath.parse('echo "Hello World"'), AutomatePath(segments: ['echo', 'Hello World']));
    expect(AutomatePath.parse('echo Hi repeat:5'), AutomatePath(segments: ['echo', 'Hi'], parameters: {'repeat': '5'}));
    expect(
      AutomatePath.parse('deploy . only:ios'),
      AutomatePath(segments: ['deploy', '.'], parameters: {'only': 'ios'}),
    );
  });
}
