import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snozzy/CustomWidgets/MainDrawer.dart';
import 'package:snozzy/Globals.dart';
import 'package:snozzy/services/Analytics.dart';
import 'package:snozzy/services/Database.dart';

//לערוך שעות של דיאלוג
//דברים של נותיפיקציות

class SettingsPage extends StatelessWidget {
  static Map<String, Duration?> deleteTimeOptions = {
    'never': null,
    'One year': Duration(days: 365),
    'One month': Duration(days: 31),
    'One week': Duration(days: 7)
  };

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder:
          // ignore: missing_return
          (BuildContext context, AsyncSnapshot<SharedPreferences> value) {
        if (value.connectionState == ConnectionState.waiting)
          return CircularProgressIndicator();
        if (value.connectionState == ConnectionState.done) {
          SharedPreferences? sharedPreferences = value.data;
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
                  Card(
                      child: DeleteFromHistory(sharedPreferences!),
                      elevation: 4),
                  /*Card(
                      child: LeaveAppOpenAfterShareWidget(sharedPreferences),
                      elevation: 8)*/
                ],
              ));
        }
        return Container();
      },
    );
  }
}

class DeleteFromHistory extends StatelessWidget {
  SharedPreferences sharedPreferences;

  DeleteFromHistory(this.sharedPreferences);

  @override
  Widget build(BuildContext context) {
    return SelectFormField(
      labelText: 'Items will be deleted from history after:',
      initialValue: sharedPreferences.containsKey('deleteFromHistory')
          ? sharedPreferences.getString('deleteFromHistory')
          : 'Never',
      items: [
        {
          'value': 'Never',
          'label': 'Never',
        },
        {
          'value': 'One year',
          'label': 'One year',
        },
        {
          'value': 'One month',
          'label': 'One month',
        },
        {
          'value': 'One week',
          'label': 'One week',
        },
      ],
      onChanged: (val) {
        Analytics.settingsAutoDeleteFromHistory(val);
        Database.deleteFromHistoryDuration =
            SettingsPage.deleteTimeOptions[val];
        sharedPreferences.setString('deleteFromHistory', val);
      },
    );
  }
}

class LeaveAppOpenAfterShareWidget extends StatefulWidget {
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
