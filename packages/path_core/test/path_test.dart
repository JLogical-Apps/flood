import 'package:path_core/path_core.dart';
import 'package:test/test.dart';

void main() {
  test('match only string path definitions', () {
    final onePathDefinition = PathDefinition.string('test');
    expect(onePathDefinition.matches('/test'), isTrue);
    expect(onePathDefinition.matches('test'), isTrue);
    expect(onePathDefinition.matches('/test/'), isFalse);
    expect(onePathDefinition.matches('bla'), isFalse);
    expect(onePathDefinition.matches('/test_bla'), isFalse);

    final twoPathDefinition = PathDefinition.string('foo').string('bar');
    expect(twoPathDefinition.matches('/foo/bar'), isTrue);
    expect(twoPathDefinition.matches('foo/bar'), isTrue);
    expect(twoPathDefinition.matches('foo/bar/'), isFalse);
    expect(twoPathDefinition.matches('bar/foo'), isFalse);
    expect(twoPathDefinition.matches('foo'), isFalse);
    expect(twoPathDefinition.matches('foo/bar/test'), isFalse);
  });

  test('match wildcard definitions', () {
    final wildcardDefinition = PathDefinition.wildcard();
    expect(wildcardDefinition.matches('/test'), isTrue);
    expect(wildcardDefinition.matches('test'), isTrue);
    expect(wildcardDefinition.matches('bla'), isTrue);
    expect(wildcardDefinition.matches('/test/'), isFalse);

    final multiDefinition = PathDefinition.string('envelope').wildcard();
    expect(multiDefinition.matches('/envelope/123'), isTrue);
    expect(multiDefinition.matches('envelope/5432123'), isTrue);
    expect(multiDefinition.matches('envelope/5432123/'), isFalse);
    expect(multiDefinition.matches('envelope/5432123/123'), isFalse);
  });
}
