import 'package:path_core/path_core.dart';
import 'package:test/test.dart';

void main() {
  test('match only string path definitions', () {
    final onePathDefinition = PathDefinition.builder().string('test').build();
    expect(onePathDefinition.matches('/test'), isTrue);
    expect(onePathDefinition.matches('test'), isTrue);
    expect(onePathDefinition.matches('/test/'), isFalse);
    expect(onePathDefinition.matches('bla'), isFalse);
    expect(onePathDefinition.matches('/test_bla'), isFalse);

    final twoPathDefinition = PathDefinition.builder().string('foo').string('bar').build();
    expect(twoPathDefinition.matches('/foo/bar'), isTrue);
    expect(twoPathDefinition.matches('foo/bar'), isTrue);
    expect(twoPathDefinition.matches('foo/bar/'), isFalse);
    expect(twoPathDefinition.matches('bar/foo'), isFalse);
    expect(twoPathDefinition.matches('foo'), isFalse);
    expect(twoPathDefinition.matches('foo/bar/test'), isFalse);
  });

  test('match wildcard definitions', () {
    final wildcardDefinition = PathDefinition.builder().wildcard().build();
    expect(wildcardDefinition.matches('/test'), isTrue);
    expect(wildcardDefinition.matches('test'), isTrue);
    expect(wildcardDefinition.matches('bla'), isTrue);
    expect(wildcardDefinition.matches('/test/'), isFalse);

    final multiDefinition = PathDefinition.builder().string('envelope').wildcard().build();
    expect(multiDefinition.matches('/envelope/123'), isTrue);
    expect(multiDefinition.matches('envelope/5432123'), isTrue);
    expect(multiDefinition.matches('envelope/5432123/'), isFalse);
    expect(multiDefinition.matches('envelope/5432123/123'), isFalse);
  });
}
