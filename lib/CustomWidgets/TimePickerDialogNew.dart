import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snozzy/Globals.dart';
import 'package:intl/intl.dart';
import 'package:snozzy/models/CustomTimeOption.dart';
import 'package:snozzy/models/SnoozyTypes.dart';
import 'package:snozzy/services/Database.dart';

import '../services/SPService.dart';

class TimePickerDialog extends StatefulWidget {
  bool isSettings = false;

  TimePickerDialog({bool? isSettings}) {
    if (isSettings != null) this.isSettings = isSettings;
  }

  _TimePickerDialogState createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<TimePickerDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 12,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 15, bottom: 15, left: 25.0, right: 25),
          child: GridView.count(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            children:
                widget.isSettings ? getSettingsTimeOptions() : getTimeOptions(),
          ),
        ),
      ),
    );
  }

  List<Widget> getTimeOptions() {
    final now = DateTime.now();
    _TimeOption tomorrowMorning = _TimeOption(
        icon: Icons.wb_sunny,
        title: 'Tomorrow morning',
        subTitle: '${weekdayToString[now.weekday + 1]} 8:00',
        value: combineDateAndTime(
            now.add(Duration(days: 1)), TimeOfDay(minute: 0, hour: 8)),
        onTap: (value, context) => save(value, context));

    _TimeOption thisAfternoon = _TimeOption(
        icon: FontAwesomeIcons.mugHot,
        title: 'This afternoon',
        subTitle: '13:00',
        value: combineDateAndTime(now, TimeOfDay(minute: 0, hour: 13)),
        onTap: (value, context) => save(value, context));

    _TimeOption thisEvening = _TimeOption(
        icon: FontAwesomeIcons.wineGlass,
        title: 'This evening',
        subTitle: '19:00',
        value: combineDateAndTime(now, TimeOfDay(minute: 0, hour: 19)),
        onTap: (value, context) => save(value, context));

    final workWeek = SPService().currentWorkWeekType;
    _TimeOption thisWeekend = _TimeOption(
        icon: Icons.weekend,
        title: 'This weekend',
        subTitle: '${workWeek.thisWeekendShortName} 10:00',
        value: setDayOfTheWeek(now, workWeek.thisWeekendDay, 10),
        onTap: (value, context) => save(value, context));

    _TimeOption nextWeek = _TimeOption(
        icon: Icons.next_week,
        title: 'Next week',
        subTitle: '${workWeek.nextWeekShortName} 8:00',
        value: setDayOfTheWeek(now, workWeek.nextWeekDay, 8),
        onTap: (value, context) => save(value, context));

    Widget addCustomTimeOption = InkWell(
        onTap: () async {
          DateTime value = await showDialog(
              context: context,
              builder: (BuildContext context) => CustomDateTimePickerDialog());
          Navigator.pop(context, value);
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.date_range,
                color: Globals.snoozyPurple,
              ),
              ListTile(
                title: Text(
                  'Custom day & time',
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ));

    Widget addNewTimeOption = InkWell(
      onTap: () async {
        final CustomTimeOption results = await showDialog(
            context: context,
            builder: (BuildContext context) => CustomTimeOptionDialog());
        setState(() {
          Database.addTimeOption(results);
        });
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: Globals.snoozyPurple,
            ),
            ListTile(
              title: Text(
                'Add a new option',
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );

    List<Widget> timeOptions = [];
    timeOptions.add(tomorrowMorning);

    //shows option only before the after noon
    if (now.hour < 13) timeOptions.add(thisAfternoon);

    //shows option only before the evening
    if (now.hour < 19) timeOptions.add(thisEvening);

    //shows option only when its now the the weekend days
    if (!workWeek.isWeekendNow) timeOptions.add(thisWeekend);

    timeOptions.add(nextWeek);
    final customOptionsModels = Database.getTimeOptions();
    timeOptions.addAll(List.generate(
        customOptionsModels.length,
        (index) =>
            _TimeOption.fromCustomTimeOption(customOptionsModels[index], () {
              setState(() {
                Database.deleteTimeOption(customOptionsModels[index].id);
              });
            })));
    timeOptions.add(addCustomTimeOption);
    timeOptions.add(addNewTimeOption);
    return timeOptions;
  }

  List<Widget> getSettingsTimeOptions() {
    Widget addNewTimeOption = InkWell(
      onTap: () async {
        final CustomTimeOption results = await showDialog(
            context: context,
            builder: (BuildContext context) => CustomTimeOptionDialog());
        setState(() {
          Database.addTimeOption(results);
        });
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: Globals.snoozyPurple,
            ),
            ListTile(
              title: Text(
                'Add a new option',
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );

    List<Widget> timeOptions = [];
    final customOptionsModels = Database.getTimeOptions();

    timeOptions.addAll(List.generate(
        customOptionsModels.length,
        (index) => _TimeOption.fromCustomTimeOption(
              customOptionsModels[index],
              () {
                setState(() {
                  Database.deleteTimeOption(customOptionsModels[index].id);
                });
              },
              isSettings: true,
            )));
    timeOptions.add(addNewTimeOption);
    return timeOptions;
  }

  static Map<int, String> weekdayToString = {
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun',
    8: 'Mon'
  };

  static DateTime setDayOfTheWeek(DateTime now, int day, int hour) {
    now = combineDateAndTime(now, TimeOfDay(hour: hour, minute: 0));
    if (now.weekday == day) now.add(Duration(days: 7));
    return now.add(Duration(days: (day - now.weekday).abs()));
  }
}

class _TimeOption extends StatelessWidget {
  late final String title, subTitle;
  late final IconData icon;
  late final DateTime value;
  late final Function onTap;
  String? customId;
  Function? onDelete;

  _TimeOption(
      {required this.title,
      required this.subTitle,
      required this.icon,
      required this.onTap,
      required this.value});

  _TimeOption.fromCustomTimeOption(
      CustomTimeOption customTimeOption, Function onDelete,
      {bool? isSettings}) {
    this.title = customTimeOption.title;
    this.subTitle = customTimeOption.subTitle;
    this.icon = Icons.star;
    this.value = DateTime.now().add(Duration(
        hours: customTimeOption.hours, minutes: customTimeOption.minutes));
    this.onTap = (value, context) {
      if (isSettings != null && isSettings) return;
      save(value, context);
    };
    this.customId = customTimeOption.id;
    this.onDelete = onDelete;
  }

  @override
  Widget build(BuildContext context) => InkWell(
      onTap: () => onTap(value, context),
      child: Stack(
        children: [
          customId != null
              ? Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () => onDelete!.call(),
                      icon: Icon(Icons.close)),
                )
              : Container(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Globals.snoozyPurple,
                ),
                ListTile(
                  title: Text(
                    title,
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Text(subTitle, textAlign: TextAlign.center),
                )
              ],
            ),
          ),
        ],
      ));
}

class CustomDateTimePickerDialog extends StatefulWidget {
  _CustomDateTimePickerDialogState createState() =>
      _CustomDateTimePickerDialogState();
}

class _CustomDateTimePickerDialogState
    extends State<CustomDateTimePickerDialog> {
  DateTime? reminderTime;
  TimeOfDay? time = TimeOfDay.now();
  DateTime? date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 18,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DateTimeField(
                format: DateFormat("yyyy-MM-dd"),
                initialValue: date,
                decoration: InputDecoration(
                    labelStyle: TextStyle(),
                    labelText: 'Click to enter date',
                    icon: Icon(Icons.calendar_today)),
                onSaved: (savedDate) {
                  date = savedDate;
                },
                onShowPicker: (context, currentValue) async {
                  date = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                  if (date == null) date = DateTime.now();
                  reminderTime = combineDateAndTime(date!, time!);
                  return date;
                }),
            DateTimeField(
                format: DateFormat("HH:mm"),
                initialValue: date,
                decoration: InputDecoration(
                    labelText: 'Click to enter time',
                    icon: Icon(Icons.access_time_outlined)),
                onShowPicker: (context, currentValue) async {
                  time = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  if (time == null) time = TimeOfDay.now();
                  reminderTime = combineDateAndTime(date!, time!);
                  return DateTimeField.convert(time);
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (isInFuture(reminderTime!))
                      Navigator.pop(context, reminderTime);
                    else
                      Fluttertoast.showToast(
                          msg: 'please select a time in the future');
                    //else
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(color: Colors.green),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTimeOptionDialog extends StatefulWidget {
  CustomTimeOptionDialog({Key? key}) : super(key: key);

  @override
  State<CustomTimeOptionDialog> createState() => _CustomTimeOptionDialogState();
}

class _CustomTimeOptionDialogState extends State<CustomTimeOptionDialog> {
  final _hoursController = TextEditingController(),
      _minutesController = TextEditingController(),
      _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
      padding: const EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("enter desired time to be snoozed",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Container(
              height: 8,
            ),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                  labelText: "option title", border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return "please enter a title";
                return null;
              },
            ),
            Container(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                      controller: _hoursController,
                      decoration: InputDecoration(
                          hintText: "0",
                          labelText: "hours",
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: false, signed: false),
                      validator: (value) {
                        if (value == null || value.isEmpty) value = "0";
                        int intValue = int.parse(value);
                        if (intValue < 0) {
                          return "please enter a positive number";
                        }
                        return null;
                      }),
                ),
                Container(
                  width: 8,
                ),
                Expanded(
                  child: TextFormField(
                      controller: _minutesController,
                      decoration: InputDecoration(
                          hintText: "0",
                          labelText: "minutes",
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: false, signed: false),
                      validator: (value) {
                        if (value == null || value.isEmpty) value = "0";
                        int intValue = int.parse(value);
                        if (intValue < 0) {
                          return "please enter a positive number";
                        }
                        return null;
                      }),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      int? hours = int.tryParse(_hoursController.text);
                      hours ??= 0;
                      int? minutes = int.tryParse(_minutesController.text);
                      minutes ??= 0;
                      if (hours == 0 && minutes == 0) {
                        Fluttertoast.showToast(
                            msg: "please fill the hours or minutes field");
                        return;
                      }
                      Navigator.pop(
                          context,
                          CustomTimeOption(
                              title: _titleController.text,
                              subTitle: getSubtitle(hours, minutes),
                              hours: hours,
                              minutes: minutes));
                    }
                  },
                  child: Text(
                    "save",
                    style: TextStyle(color: Colors.green),
                  )),
            )
          ],
        ),
      ),
    ));
  }

  String getSubtitle(int hours, int minutes) {
    if (minutes == 0 && hours == 0) return 'now';
    if (minutes == 0) return "in $hours hours";
    if (hours == 0) return "in $minutes minutes";
    return "in $hours hours and $minutes minutes";
  }
}

DateTime combineDateAndTime(DateTime dateTime, TimeOfDay timeOfDay) {
  return DateTimeField.combine(dateTime, timeOfDay);
}

bool isInFuture(DateTime date) {
  return date.isAfter(DateTime.now());
}

void save(DateTime value, BuildContext context) =>
    Navigator.pop(context, value);
