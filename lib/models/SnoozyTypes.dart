enum WorkWeekType { sun_thu, mon_fri }

extension WorkWeekTypeExtension on WorkWeekType {
  String get thisWeekendShortName {
    switch (this) {
      case WorkWeekType.sun_thu:
        return "Fri";
      case WorkWeekType.mon_fri:
        return "Sat";
    }
  }

  int get thisWeekendDay {
    switch (this) {
      case WorkWeekType.sun_thu:
        return 5;
      case WorkWeekType.mon_fri:
        return 6;
    }
  }

  String get nextWeekShortName {
    switch (this) {
      case WorkWeekType.sun_thu:
        return "Sun";
      case WorkWeekType.mon_fri:
        return "Mon";
    }
  }

  int get nextWeekDay {
    switch (this) {
      case WorkWeekType.sun_thu:
        return 7;
      case WorkWeekType.mon_fri:
        return 8;
    }
  }

  bool get isWeekendNow {
    final now = DateTime.now();
    switch (this) {
      case WorkWeekType.sun_thu:
        return now.weekday == 5 || now.weekday == 6;
      case WorkWeekType.mon_fri:
        return now.weekday == 6 || now.weekday == 7;
    }
  }
}

enum AutoDeleteHistoryType { never, one_year, one_month, one_week }

extension AutoDeleteHistoryTypeExtension on AutoDeleteHistoryType {
  Duration? get value {
    switch (this) {
      case (AutoDeleteHistoryType.one_year):
        return Duration(days: 365);
      case AutoDeleteHistoryType.never:
        return null;
      case AutoDeleteHistoryType.one_month:
        return Duration(days: 31);
      case AutoDeleteHistoryType.one_week:
        return Duration(days: 7);
    }
    return null;
  }
}
