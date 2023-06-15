abstract class StatePersisterModifier {
  Map<String, dynamic> persist(Map<String, dynamic> data) => data;

  Map<String, dynamic> inflate(Map<String, dynamic> data) => data;
}
