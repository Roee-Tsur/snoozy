import 'package:flutter/material.dart';
import 'package:snozzy/Globals.dart';
import 'package:snozzy/models/SharedItem.dart';

class NewTitleDialog extends StatefulWidget {
  SharedItem sharedItem;

  NewTitleDialog(this.sharedItem);

  _NewTitleDialogState createState() => _NewTitleDialogState();
}

class _NewTitleDialogState extends State<NewTitleDialog> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Rename item:',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          Text(
            widget.sharedItem.title,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          Container(
              width: MediaQuery.of(context).size.width*0.6,
              child: TextField(
                cursorColor: Globals.snoozyPurple,
                autofocus: true,
                controller: controller,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Globals.snoozyPurple),
                  )),
              Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8),
                child: TextButton(
                  child: Text('Rename',
                      style: TextStyle(color: Globals.snoozyPurple)),
                  onPressed: () {
                    widget.sharedItem.setNewTitle(controller.text);
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }
}
