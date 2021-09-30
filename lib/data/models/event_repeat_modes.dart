enum EventRepeatMode {
  doNotRepeat,
  daily,
  weekly,
  monthly,
  yearly,
}

Map<EventRepeatMode, String> repeatValues = {
  EventRepeatMode.doNotRepeat: "Do not repeat",
  EventRepeatMode.daily: "Daily",
  EventRepeatMode.weekly: "Weekly",
  EventRepeatMode.monthly: "Monthly",
  EventRepeatMode.yearly: "Yearly",
};
