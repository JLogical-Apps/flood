extension DateTimeExtensions on DateTime {
  DateTime withoutTime() {
    return DateTime(this.year, this.month, this.day);
  }
}
