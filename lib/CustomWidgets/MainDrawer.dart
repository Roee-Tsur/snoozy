import 'package:flutter/material.dart';
import 'package:snozzy/Pages/HistoryPage.dart';
import 'package:snozzy/Pages/MainListPage.dart';
import 'package:snozzy/Pages/SettingsPage.dart';
import 'package:snozzy/services/Analytics.dart';

enum CurrentPage { History, MainList, Setting }

class MainDrawer extends StatelessWidget {
  final CurrentPage currentPage;

  MainDrawer(this.currentPage);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Image.asset('assets/logo.jpg'),
          ),
          InkWell(
            child: ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                tileColor: currentPage == CurrentPage.MainList
                    ? Colors.purple.shade200
                    : Colors.white,
                onTap: () {
                  if (currentPage == CurrentPage.MainList) return;
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(MainListPage.routeName),
                  );
                  Analytics.setCurrentScreen('MainPage');
                }),
          ),
          InkWell(
            child: ListTile(
                leading: Icon(Icons.history),
                title: Text('History'),
                tileColor: currentPage == CurrentPage.History
                    ? Colors.purple.shade200
                    : Colors.white,
                onTap: () {
                  Navigator.pop(context);
                  if (currentPage == CurrentPage.History) return;
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    HistoryPage.routeName,
                    ModalRoute.withName(MainListPage.routeName),
                  );
                  Analytics.setCurrentScreen('HistoryPage');
                }),
          ),
          InkWell(
            child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                tileColor: currentPage == CurrentPage.Setting
                    ? Colors.purple.shade200
                    : Colors.white,
                onTap: () {
                  Navigator.pop(context);
                  if (currentPage == CurrentPage.Setting) return;
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    SettingsPage.routeName,
                    ModalRoute.withName(MainListPage.routeName),
                  );
                  Analytics.setCurrentScreen('SettingsPage');
                }),
          ),
          /*InkWell(
            child: ListTile(
              title: Text('Review Us'),
              //onTap: () => Navigator.push(context, HistoryPage),
            ),
          )*/
        ],
      ),
    );
  }
}
