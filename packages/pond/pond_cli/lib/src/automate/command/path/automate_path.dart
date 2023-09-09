import 'package:equatable/equatable.dart';
import 'package:utils_core/utils_core.dart';

class AutomatePath with EquatableMixin {
  final List<String> segments;
  final Map<String, String> parameters;

  AutomatePath({required this.segments, this.parameters = const {}});

  static AutomatePath parse(String path) {
    final segments = <String>[];
    final parameters = <String, String>{};

    final pattern = RegExp(r'"(.*?)"|\S+');
    final matches = pattern.allMatches(path);
    for (final match in matches) {
      final part = match.group(0)!;
      if (part.startsWith('"') && part.endsWith('"')) {
        segments.add(part.substring(1, part.length - 1));
      } else if (part.contains(':')) {
        final paramParts = part.split(':');
        parameters[paramParts[0]] = paramParts[1];
      } else {
        segments.add(part);
      }
    }

    return AutomatePath(segments: segments, parameters: parameters);
  }

  @override
  List<Object?> get props => [
        segments,
        parameters,
      ];

  @override
  String toString() {
    return segments.join(' ') + parameters.mapToIterable((name, value) => '$name:$value').join(' ');
  }
}
