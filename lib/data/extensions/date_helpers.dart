extension Formatting on DateTime {
  String getDashedDate() =>
      "$year-${month.addLeadingZeros(2)}-${day.addLeadingZeros(2)}";
  String get time => "${hour.addLeadingZeros(2)}:${minute.addLeadingZeros(2)}";
}

extension LeadingZeros on int {
  String addLeadingZeros(int numberOfTotalDigits) =>
      toString().padLeft(numberOfTotalDigits, '0');
}

extension Months on DateTime {
  int get previousMonthNumber => month - 1 <= 0 ? 12 : month - 1;

  int get nextMonthNumber => month + 1 >= 13 ? 1 : month + 1;

  DateTime get previousMonth =>
      DateTime(month - 1 <= 0 ? year - 1 : year, previousMonthNumber, 1);

  DateTime get nextMonth =>
      DateTime(month + 1 >= 13 ? year + 1 : year, nextMonthNumber, 1);

  DateTime get firstDayOfMonth => DateTime(year, month, 1);
}
