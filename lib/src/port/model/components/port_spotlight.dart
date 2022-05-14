import '../fields/options_port_field.dart';
import '../port_component.dart';
import '../port_field.dart';

/// Based off the value, enables only one field from a list of candidates.
class PortSpotlight extends PortComponent {
  /// The name of the generated option field.
  final String optionFieldName;

  final bool canBeNone;

  final List<PortField> candidates;

  final String? initialCandidateName;

  List<String> get candidateNames => candidates.map((candidate) => candidate.name).toList();

  PortSpotlight({
    required this.optionFieldName,
    this.canBeNone: false,
    this.initialCandidateName,
    required this.candidates,
  });

  @override
  void onInitialize() {
    port.withField(OptionsPortField(
      name: optionFieldName,
      options: candidateNames,
      canBeNone: canBeNone,
      initialValue: initialCandidateName,
    ));
    candidates.forEach(
        (candidate) => port.withField(candidate.validateIf((value, port) => port[optionFieldName] == candidate.name)));
  }
}
