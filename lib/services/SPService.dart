import 'package:shared_preferences/shared_preferences.dart';
import 'package:snozzy/models/SnoozyTypes.dart';

class SPService {
  final String _workWeekKey = 'work week';
  final String _autoDeleteHistoryKey = 'auto delete';
  late SharedPreferences _sharedPreferences;

  static final SPService _instance = SPService._internal();

  factory SPService() => _instance;

  SPService._internal();

  init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  WorkWeekType get currentWorkWeekType {
    if (_sharedPreferences.containsKey(_workWeekKey)) {
      return WorkWeekType.values.firstWhere(
          (element) => element.name == _sharedPreferences.getString(_workWeekKey)!);
    }
    return WorkWeekType.mon_fri;
  }

  set currentWorkWeekType(WorkWeekType type) =>
      _sharedPreferences.setString(_workWeekKey, type.name);

  AutoDeleteHistoryType get currentAutoDeleteHistoryType {
    if (_sharedPreferences.containsKey(_autoDeleteHistoryKey)) {
      return AutoDeleteHistoryType.values.firstWhere(
              (element) => element.name == _sharedPreferences.getString(_autoDeleteHistoryKey)!);
    }
    return AutoDeleteHistoryType.never;
  }

  set currentAutoDeleteHistoryType(AutoDeleteHistoryType type) =>
      _sharedPreferences.setString(_autoDeleteHistoryKey, type.name);
}
