import 'package:path_core/path_core.dart';
import 'package:test/test.dart';

void main() {
  test('match only string path definitions', () {
    final onePathDefinition = PathDefinition.string('test');
    expect(onePathDefinition.matchesPath('/test'), isTrue);
    expect(onePathDefinition.matchesPath('test'), isTrue);
    expect(onePathDefinition.matchesPath('/test/'), isFalse);
    expect(onePathDefinition.matchesPath('bla'), isFalse);
    expect(onePathDefinition.matchesPath('/test_bla'), isFalse);

    final twoPathDefinition = PathDefinition.string('foo').string('bar');
    expect(twoPathDefinition.matchesPath('/foo/bar'), isTrue);
    expect(twoPathDefinition.matchesPath('foo/bar'), isTrue);
    expect(twoPathDefinition.matchesPath('foo/bar/'), isFalse);
    expect(twoPathDefinition.matchesPath('bar/foo'), isFalse);
    expect(twoPathDefinition.matchesPath('foo'), isFalse);
    expect(twoPathDefinition.matchesPath('foo/bar/test'), isFalse);
  });

  test('match wildcard definitions', () {
    final wildcardDefinition = PathDefinition.wildcard();
    expect(wildcardDefinition.matchesPath('/test'), isTrue);
    expect(wildcardDefinition.matchesPath('test'), isTrue);
    expect(wildcardDefinition.matchesPath('bla'), isTrue);
    expect(wildcardDefinition.matchesPath('/test/'), isFalse);

    final multiDefinition = PathDefinition.string('envelope').wildcard();
    expect(multiDefinition.matchesPath('/envelope/123'), isTrue);
    expect(multiDefinition.matchesPath('envelope/5432123'), isTrue);
    expect(multiDefinition.matchesPath('envelope/5432123/'), isFalse);
    expect(multiDefinition.matchesPath('envelope/5432123/123'), isFalse);
  });
}
