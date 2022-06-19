import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'CustomTimeOption.g.dart';

@HiveType(typeId: 8)
class CustomTimeOption extends HiveObject {
  //String iconName;
  @HiveField(0)
  late String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String subTitle;

  ///time is the future
  @HiveField(3)
  int hours = 0;
  @HiveField(4)
  int minutes = 0;

  CustomTimeOption(
      {required this.title,
      required this.subTitle,
      required this.hours,
      required this.minutes}) {
    this.id = Uuid().v1();
  }
}
