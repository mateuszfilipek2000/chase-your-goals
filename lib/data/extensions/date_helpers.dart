extension DashedDate on DateTime {
  String getDashedDate() =>
      "$year-${month.addLeadingZeros(2)}-${day.addLeadingZeros(2)}";
}

extension LeadingZeros on int {
  String addLeadingZeros(int numberOfTotalDigits) =>
      toString().padLeft(numberOfTotalDigits, '0');
}
