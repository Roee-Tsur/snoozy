import 'package:flutter/material.dart';

import '../Globals.dart';

class GlobalWidgets {
  static Widget rightDismissable = Container(
    alignment: Alignment.centerRight,
    color: Globals.snoozyPurple,
    child: Padding(
      padding: EdgeInsets.all(18.0),
      child: Icon(Icons.delete),
    ),
  );

  static Widget leftDismissable = Container(
    alignment: Alignment.centerLeft,
    color: Globals.snoozyPurple,
    child: Padding(
      padding: EdgeInsets.all(18.0),
      child: Icon(Icons.delete),
    ),
  );
}
