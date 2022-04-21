import 'dart:core';

import 'package:flutter/material.dart';
import 'package:snozzy/CustomWidgets/MainDrawer.dart';
import 'package:snozzy/CustomWidgets/TimePickerDialogNew.dart' as TPD;
import 'package:snozzy/Globals.dart';
import 'package:snozzy/models/SnoozyTypes.dart';

import '../services/Database.dart';
import '../services/SPService.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Settings',
            style: TextStyle(
              color: Globals.strongGray,
            ),
          ),
        ),
        drawer: MainDrawer(CurrentPage.Setting),
        body: ListView(
          children: [
            AutoDeleteHistoryCard(),
            WorkWeekCard(),
            EditTimeOptionCard()
          ],
        ));
  }
}

class AutoDeleteHistoryCard extends StatefulWidget {
  @override
  State<AutoDeleteHistoryCard> createState() => _AutoDeleteHistoryCardState();
}

class _AutoDeleteHistoryCardState extends State<AutoDeleteHistoryCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //todo add auto delete icon
            Text("Items will automatically delete from history"),
            DropdownButton<AutoDeleteHistoryType>(
                value: SPService().currentAutoDeleteHistoryType,
                isExpanded: true,
                iconSize: 30,
                underline: Container(),
                items: [
                  DropdownMenuItem<AutoDeleteHistoryType>(
                    child: Text('Never'),
                    value: AutoDeleteHistoryType.never,
                  ),
                  DropdownMenuItem<AutoDeleteHistoryType>(
                    child: Text('Once a year'),
                    value: AutoDeleteHistoryType.one_year,
                  ),
                  DropdownMenuItem<AutoDeleteHistoryType>(
                    child: Text('Once a month'),
                    value: AutoDeleteHistoryType.one_month,
                  ),
                  DropdownMenuItem<AutoDeleteHistoryType>(
                    child: Text('Once a week'),
                    value: AutoDeleteHistoryType.one_week,
                  ),
                ],
                onChanged: (AutoDeleteHistoryType? type) {
                  Database.deleteFromHistoryDuration = type!.value;
                  setState(() {
                    SPService().currentAutoDeleteHistoryType = type;
                  });
                }),
          ],
        ),
      ),
    );
  }
}

class WorkWeekCard extends StatefulWidget {
  WorkWeekCard({Key? key}) : super(key: key);

  @override
  State<WorkWeekCard> createState() => _WorkWeekCardState();
}

class _WorkWeekCardState extends State<WorkWeekCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('my work week'),
            DropdownButton<WorkWeekType>(
                value: SPService().currentWorkWeekType,
                isExpanded: true,
                iconSize: 30,
                underline: Container(),
                items: [
                  DropdownMenuItem<WorkWeekType>(
                    child: Text(
                      "Monday-Friday",
                    ),
                    value: WorkWeekType.mon_fri,
                  ),
                  DropdownMenuItem<WorkWeekType>(
                    child: Text(
                      "Sunday-Thursday",
                    ),
                    value: WorkWeekType.sun_thu,
                  )
                ],
                onChanged: (WorkWeekType? type) {
                  //Analytics.settingsAutoDeleteFromHistory(val);
                  if (type == null) {
                    print("WorkWeekType is null");
                    return;
                  }
                  setState(() {
                    SPService().currentWorkWeekType = type;
                  });
                }),
          ],
        ),
      ),
    );
  }
}

class EditTimeOptionCard extends StatefulWidget {
  const EditTimeOptionCard({Key? key}) : super(key: key);

  @override
  State<EditTimeOptionCard> createState() => _EditTimeOptionCardState();
}

class _EditTimeOptionCardState extends State<EditTimeOptionCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2,
        child: TextButton(
            child: Text("edit time options"),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => TPD.TimePickerDialog(
                        isSettings: true,
                      ));
            }),
      ),
    );
  }
}

/*class LeaveAppOpenAfterShareWidget extends StatefulWidget {
  SharedPreferences sharedPreferences;

  LeaveAppOpenAfterShareWidget(this.sharedPreferences);

  _LeaveAppOpenAfterShareWidgetState createState() =>
      _LeaveAppOpenAfterShareWidgetState();
}

class _LeaveAppOpenAfterShareWidgetState
    extends State<LeaveAppOpenAfterShareWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Leave the app open after adding a new item'),
      trailing: Switch(
        onChanged: (value) {
          widget.sharedPreferences.setBool('leaveAppOpenAfterShare', value);
          setState(() {});
        },
        value: widget.sharedPreferences.containsKey('leaveAppOpenAfterShare')
            ? widget.sharedPreferences.getBool('leaveAppOpenAfterShare')!
            : true,
      ),
    );
  }
}
*/
