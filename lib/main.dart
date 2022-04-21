import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snozzy/Globals.dart';
import 'package:snozzy/models/SharedItem.dart';
import 'package:snozzy/models/SnoozyTypes.dart';
import 'package:snozzy/services/Analytics.dart';
import 'package:snozzy/services/SPService.dart';

import 'services/Database.dart';
import 'Pages/MainListPage.dart';

//add multi-language support
//settings: leave app open after share, control notifications
//custom time option: customize icon
//clean up routing
//show weekend option correct to workweek
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Database.databaseInit();
  await SPService().init();

  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'snoozy_notifications',
        channelName: 'Snoozy notifications',
        channelDescription: 'Notification channel for Snoozy app',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white)
  ]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  int numOfBuilds = 0;

  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  MyAppState() {
    //Ads.initAdMob(this);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.numOfBuilds++;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Analytics.setCurrentScreen('MainPage');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [Analytics.getNavigatorObserver()],
      home: Builder(
        // ignore: missing_return
        builder: (BuildContext context) {
          if (widget.numOfBuilds == 1)
            AwesomeNotifications().actionStream.listen((notificationClicked) {
              SharedItem sharedItem = Database.getItemById(Database.sharesList,
                  notificationClicked.payload!['sharedItemId']!);
              Analytics.notificationClicked(sharedItem.typeToText());
              MainListPageState.openItemViewer(
                  sharedItem, context, 'notification');
              setState(() {});
            });
          return MainListPage();
        },
      ),
      color: Colors.white,
      theme: ThemeData(
        primaryColor: Globals.strongGray,
        primaryTextTheme: TextTheme().apply(
          bodyColor: Globals.strongGray,
          displayColor: Globals.strongGray,
          decorationColor: Globals.strongGray,
        ),
        accentColor: Globals.strongGray,
        accentIconTheme: IconThemeData(color: Globals.strongGray),
        appBarTheme: AppBarTheme(
            color: Colors.white,
            iconTheme: IconThemeData(color: Globals.strongGray)),
        textTheme: TextTheme().apply(
          bodyColor: Globals.strongGray,
          displayColor: Globals.strongGray,
          decorationColor: Globals.strongGray,
        ),
      ),
    );
  }
}
