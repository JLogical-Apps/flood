extension DateTimeExtensions on DateTime {
  DateTime withoutTime() {
    return DateTime(year, month, day);
  }
}
