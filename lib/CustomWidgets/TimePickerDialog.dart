// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_picker/Picker.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:snozzy/Globals.dart';
// import 'package:intl/intl.dart';
//
// class ReminderTimeDialog extends StatefulWidget {
//   _ReminderTimeDialogState createState() => _ReminderTimeDialogState();
// }
//
// class _ReminderTimeDialogState extends State<ReminderTimeDialog> {
//   SharedPreferences sharedPreferences;
//   TimeOfDay time;
//   String selectedTile;
//
//   setSelectedTile(String tile) {
//     setState(() {
//       selectedTile = tile;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//         elevation: 12,
//         child: FutureBuilder(
//             future: SharedPreferences.getInstance(),
//             builder:
//                 // ignore: missing_return
//                 (BuildContext context, AsyncSnapshot<SharedPreferences> value) {
//               if (value.connectionState == ConnectionState.waiting)
//                 return CircularProgressIndicator();
//               if (value.connectionState == ConnectionState.done) {
//                 sharedPreferences = value.data;
//                 Map<String, dynamic> savedValues = getSavedValues();
//                 time = stringToTimeOfDay(savedValues['timeOfDay']);
//                 return StatefulBuilder(
//                   builder: (innerContext, setInnerState) => Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                           child: Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(bottom: 8.0),
//                             child: Text(
//                               "When do you want to be snoozed?",
//                               style: TextStyle(fontSize: 18),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                           _OptionListTile(
//                             type: 'minutes',
//                             selectedTile: selectedTile,
//                             onChanged: (tile) =>
//                                 setInnerState(() => selectedTile = tile),
//                             onEditIconTaped: () async => await setNewTimeDialog(
//                                 context,
//                                 'minutes',
//                                 getSavedValues()['minutes'],
//                                 60),
//                             title: Text(
//                               "In " +
//                                   savedValues['minutes'].toString() +
//                                   " minute" +
//                                   (savedValues['minutes'] != 1 ? 's' : ''),
//                             ),
//                           ),
//                           _OptionListTile(
//                             type: 'hours',
//                             selectedTile: selectedTile,
//                             title: Text(
//                               "In " +
//                                   savedValues['hours'].toString() +
//                                   " hour" +
//                                   (savedValues['hours'] != 1 ? 's' : ''),
//                             ),
//                             onEditIconTaped: () async => await setNewTimeDialog(
//                                 context,
//                                 'hours',
//                                 getSavedValues()['hours'],
//                                 24),
//                             onChanged: (tile) =>
//                                 setInnerState(() => selectedTile = tile),
//                           ),
//                           _OptionListTile(
//                             onChanged: (tile) =>
//                                 setInnerState(() => selectedTile = tile),
//                             onEditIconTaped: () async => await setNewTimeDialog(
//                                 context, 'days', getSavedValues()['days'], 31),
//                             title: Text(
//                               (savedValues['days'] != 1
//                                   ? "In " +
//                                       savedValues['days'].toString() +
//                                       " days"
//                                   : 'Tomorrow at this time'),
//                             ),
//                             selectedTile: selectedTile,
//                             type: 'days',
//                           ),
//                           RadioListTile(
//                               value: 'timeOfDay',
//                               groupValue: selectedTile,
//                               selected: 'timeOfDay' == selectedTile,
//                               onChanged: (tile) =>
//                                   setInnerState(() => selectedTile = tile),
//                               title: Text(
//                                 "At ${savedValues['timeOfDay']}",
//                               ),
//                               secondary: Padding(
//                                 padding: EdgeInsets.only(left: 20),
//                                 child: SizedBox(
//                                   width: 35,
//                                   height: 35,
//                                   child: DateTimeField(
//                                       format: DateFormat("HH:mm"),
//                                       decoration: InputDecoration(
//                                           icon: Icon(Icons.edit)),
//                                       onShowPicker:
//                                           // ignore: missing_return
//                                           (context, currentValue) async {
//                                         time = await showTimePicker(
//                                           context: context,
//                                           initialTime: TimeOfDay.now(),
//                                         );
//                                         if (time != null) saveTimeOfDay(time);
//                                       }),
//                                 ),
//                               )),
//                           _OptionListTile(
//                               title: Text('Save without a reminder'),
//                               selectedTile: selectedTile,
//                               onChanged: (tile) =>
//                                   setInnerState(() => selectedTile = tile),
//                               type: 'noReminder'),
//                           TextButton(
//                               child: Text(
//                                 "Custom time",
//                                 style: TextStyle(color: Globals.textBlack),
//                               ),
//                               onPressed: () async {
//                                 DateTime reminderTime = await showDialog(
//                                     barrierColor: Colors.black.withOpacity(.75),
//                                     context: context,
//                                     builder: (BuildContext context) =>
//                                         CustomDateTimePickerDialog());
//                                 if (reminderTime != null)
//                                   Navigator.pop(context, reminderTime);
//                               }),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               TextButton(
//                                 child: Text(
//                                   'save',
//                                   style: TextStyle(color: Globals.snoozyPurple),
//                                 ),
//                                 onPressed: () {
//                                   if (selectedTile == null) {
//                                     Fluttertoast.showToast(
//                                         msg: 'please select a reminder option');
//                                     return;
//                                   }
//                                   return saveTime(savedValues[selectedTile],
//                                       selectedTile, context);
//                                 },
//                               ),
//                             ],
//                           )
//                         ],
//                       )),
//                     ],
//                   ),
//                 );
//               }
//             }));
//   }
//
//   saveTime(savedValue, String type, BuildContext context) {
//     DateTime reminderTime = DateTime.now();
//     switch (type) {
//       case ('minutes'):
//         reminderTime = reminderTime.add(Duration(minutes: savedValue));
//         break;
//       case ('hours'):
//         reminderTime = reminderTime.add(Duration(hours: savedValue));
//         break;
//       case ('days'):
//         reminderTime = reminderTime.add(Duration(days: savedValue));
//         break;
//       case ('timeOfDay'):
//         savedValue = stringToTimeOfDay(savedValue);
//         reminderTime = combineDateAndTime(reminderTime, savedValue);
//         print(reminderTime);
//         if (!isInFuture(reminderTime))
//           reminderTime = reminderTime.add(Duration(days: 1));
//         break;
//       case ('noReminder'):
//         reminderTime = null;
//         break;
//     }
//     Navigator.pop(context, reminderTime);
//   }
//
//   void saveTimeOfDay(TimeOfDay time) {
//     String stringTime = '${time.hour}:${time.minute}';
//     if (time.minute < 10) stringTime = stringTime.replaceFirst(':', ':0');
//     sharedPreferences.setString('timeOfDay', stringTime);
//     setState(() {});
//   }
//
//   TimeOfDay stringToTimeOfDay(String timeString) {
//     int hours = int.parse(timeString.split(':')[0]);
//     int minutes = int.parse(timeString.split(':')[1]);
//     return TimeOfDay(minute: minutes, hour: hours);
//   }
//
//   Map<String, dynamic> getSavedValues() {
//     Map<String, dynamic> savedValues = Map<String, dynamic>();
//
//     if (!sharedPreferences.containsKey('minutes'))
//       sharedPreferences.setInt('minutes', 15);
//     savedValues['minutes'] = sharedPreferences.getInt('minutes');
//
//     if (!sharedPreferences.containsKey('hours'))
//       sharedPreferences.setInt('hours', 2);
//     savedValues['hours'] = sharedPreferences.getInt('hours');
//
//     if (!sharedPreferences.containsKey('days'))
//       sharedPreferences.setInt('days', 1);
//     savedValues['days'] = sharedPreferences.getInt('days');
//
//     if (!sharedPreferences.containsKey('timeOfDay'))
//       sharedPreferences.setString('timeOfDay', '20:00');
//     savedValues['timeOfDay'] = sharedPreferences.getString('timeOfDay');
//
//     return savedValues;
//   }
//
//   void setNewTimeDialog(
//       BuildContext context, String type, int oldValue, numOfOptions) async {
//     Picker(
//         adapter: PickerDataAdapter<String>(
//           pickerdata: getPickerData(type, numOfOptions),
//         ),
//         onConfirm: (picker, list) {
//           String value = picker.adapter.text;
//           int newValue;
//           if (value == null)
//             newValue = getSavedValues()[type];
//           else
//             newValue = int.parse(value[1]);
//           sharedPreferences.setInt(type, newValue);
//           setState(() {});
//         }).showModal(context);
//   }
//
//   List<String> getPickerData(String type, int numOfOptions) {
//     List<String> pickerData = [];
//
//     String firstValue = '1 $type'.substring(0, type.length + 1);
//     pickerData.add(firstValue);
//     for (int i = 2; i <= numOfOptions; i++) {
//       pickerData.add(i.toString() + ' ' + type);
//     }
//
//     return pickerData;
//   }
// }
//
// class _OptionListTile extends StatelessWidget {
//   String type, selectedTile;
//   Function onChanged, onEditIconTaped;
//   Text title;
//
//   _OptionListTile(
//       {this.type,
//       this.selectedTile,
//       this.onChanged,
//       this.onEditIconTaped,
//       this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return RadioListTile(
//         value: type,
//         groupValue: selectedTile,
//         onChanged: onChanged,
//         selected: type == selectedTile,
//         title: title,
//         secondary: onEditIconTaped != null
//             ? IconButton(
//                 icon: Icon(Icons.edit),
//                 onPressed: onEditIconTaped,
//               )
//             : null);
//   }
// }
//
// class _EditTimeDialog extends StatelessWidget {
//   String type;
//   int value;
//
//   _EditTimeDialog(this.type, this.value);
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//         elevation: 18,
//         child: Container(
//           padding: EdgeInsets.all(4),
//           child: Row(
//             children: [
//               Expanded(
//                 child: SizedBox(
//                   width: 280,
//                   child: TextField(
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Enter $type',
//                     ),
//                     onChanged: (str) => value = int.parse(str),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.check),
//                 onPressed: () {
//                   if (value > 0)
//                     Navigator.pop(context, value);
//                   else
//                     ; //toast about not zero
//                 },
//               )
//             ],
//           ),
//         ));
//   }
// }
//
// class CustomDateTimePickerDialog extends StatefulWidget {
//   TimeOfDay time = TimeOfDay.now();
//   DateTime date = DateTime.now();
//
//   _CustomDateTimePickerDialogState createState() =>
//       _CustomDateTimePickerDialogState();
// }
//
// class _CustomDateTimePickerDialogState
//     extends State<CustomDateTimePickerDialog> {
//   DateTime reminderTime;
//   TimeOfDay time;
//   DateTime date;
//
//   @override
//   Widget build(BuildContext context) {
//     time = widget.time;
//     date = widget.date;
//     return Dialog(
//       elevation: 18,
//       child: Container(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Column(children: [
//               DateTimeField(
//                   format: DateFormat("yyyy-MM-dd"),
//                   initialValue: date,
//                   decoration: InputDecoration(
//                       labelStyle: TextStyle(),
//                       labelText: 'Click to enter date',
//                       icon: Icon(Icons.calendar_today)),
//                   onSaved: (savedDate) {
//                     date = savedDate;
//                   },
//                   onShowPicker: (context, currentValue) async {
//                     date = await showDatePicker(
//                         context: context,
//                         firstDate: DateTime.now(),
//                         initialDate: currentValue ?? DateTime.now(),
//                         lastDate: DateTime(2100));
//                     if (date == null) date = DateTime.now();
//                     reminderTime = combineDateAndTime(date, time);
//                     return date;
//                   }),
//               DateTimeField(
//                   format: DateFormat("HH:mm"),
//                   initialValue: date,
//                   decoration: InputDecoration(
//                       labelText: 'Click to enter time',
//                       icon: Icon(Icons.access_time_outlined)),
//                   onShowPicker: (context, currentValue) async {
//                     time = await showTimePicker(
//                       context: context,
//                       initialTime: TimeOfDay.fromDateTime(
//                           currentValue ?? DateTime.now()),
//                     );
//                     if (time == null) time = TimeOfDay.now();
//                     reminderTime = combineDateAndTime(date, time);
//                     return DateTimeField.convert(time);
//                   }),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context, null),
//                     child: Text(
//                       'Cancel',
//                       style: TextStyle(color: Colors.redAccent),
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       if (isInFuture(reminderTime))
//                         Navigator.pop(context, reminderTime);
//                       else
//                         Fluttertoast.showToast(
//                             msg: 'please select a time in the future');
//                       //else
//                     },
//                     child: Text(
//                       'Done',
//                       style: TextStyle(color: Colors.green),
//                     ),
//                   )
//                 ],
//               )
//             ]),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// DateTime combineDateAndTime(DateTime dateTime, TimeOfDay timeOfDay) {
//   return DateTimeField.combine(dateTime, timeOfDay);
// }
//
// bool isInFuture(DateTime date) {
//   return date.isAfter(DateTime.now());
// }
