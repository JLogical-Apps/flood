import 'package:port_core/port_core.dart';
import 'package:test/test.dart';

void main() {
  test('basic port', () async {
    const name = 'John Doe';

    final port = Port.of({
      'name': PortValue.string(),
    });

    expect(port['name'], '');

    port.setValue(name: 'name', value: name);

    expect(port['name'], name);

    final result = await port.submit();

    expect(result.isValid, true);
    expect(result.data['name'], name);
  });

  test('basic port validation', () async {
    const name = 'John Doe';
    const email = 'doe@mail.com';

    final port = Port.of({
      'name': PortValue.string().isNotBlank(),
      'email': PortValue.string().isNotBlank().isEmail(),
    });

    expect(port['name'], '');
    expect(port['email'], '');

    var result = await port.submit();
    expect(result.isValid, false);
    expect(port.getErrorByName('name'), isNotNull);
    expect(port.getErrorByName('email'), isNotNull);

    port.setValue(name: 'name', value: name);
    port.setValue(name: 'email', value: 'invalidEmail');

    result = await port.submit();
    expect(result.isValid, false);
    expect(port.getErrorByName('name'), isNull);
    expect(port.getErrorByName('email'), isNotNull);

    port.setValue(name: 'email', value: email);

    result = await port.submit();
    expect(result.isValid, true);
    expect(result.data['name'], name);
    expect(result.data['email'], email);
  });
}
