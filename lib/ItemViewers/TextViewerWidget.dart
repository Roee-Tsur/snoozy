import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:share/share.dart';
import 'package:snozzy/Globals.dart';
import 'package:snozzy/Pages/ItemViewerPage.dart';
import 'package:snozzy/models/TextItem.dart';
import 'package:snozzy/services/Analytics.dart';
import 'package:string_validator/string_validator.dart';

class TextViewerWidget extends StatefulWidget
    implements ItemViewerContentWidget {
  TextItem textItem;
  double textSize = 18;

  TextViewerWidget(this.textItem);

  TextViewerWidgetState createState() => TextViewerWidgetState();

  @override
  List<PopupMenuItem> getPopupMenuButtons() {
    return [
      PopupMenuItem(
          child: TextButton(
        onPressed: () => Clipboard.setData(ClipboardData(text: textItem.text)),
        child: Row(
          children: [
            Icon(Icons.copy, color: Globals.strongGray),
            SizedBox(width: 10),
            Text('Copy to clipboard',
                style: TextStyle(color: Globals.textBlack)),
          ],
        ),
      )),
      PopupMenuItem(
          child: TextButton(
        onPressed: () => Share.share(textItem.text),
        child: Row(
          children: [
            Icon(Icons.share_outlined, color: Globals.strongGray),
            SizedBox(width: 10),
            Text('Share', style: TextStyle(color: Globals.textBlack)),
          ],
        ),
      ))
    ];
  }
}

class TextViewerWidgetState extends State<TextViewerWidget> {
  @override
  Widget build(BuildContext context) {
    String text = widget.textItem.text;
    Map link = doesContainLink(text);

    if (link['trueOrFalse']) text = text.replaceFirst(link['link'], '');

    return ListView(
      children: [
        Center(
          child: Row(
            children: [
              IconButton(
                  icon: Icon(Icons.zoom_in, size: 30),
                  onPressed: () {
                    widget.textSize += 4;
                    setState(() {});
                  }),
              Padding(padding: EdgeInsets.only(left: 20)),
              IconButton(
                  icon: Icon(Icons.zoom_out, size: 30),
                  onPressed: () {
                    widget.textSize -= 4;
                    setState(() {});
                  })
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: RichText(
                text: TextSpan(
                    text: text,
                    style: TextStyle(
                        fontSize: widget.textSize, color: Globals.strongGray),
                    children: [
                  link['trueOrFalse']
                      ? TextSpan(
                          text: link['link'],
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      settings: RouteSettings(
                                          name: 'link opened from textItem'),
                                      builder: (context) {
                                        Analytics.setCurrentScreen('link opened from textItem');
                                        return Scaffold(
                                            body: InAppWebView(
                                                initialUrlRequest: URLRequest(
                                                    url: Uri.parse(
                                                        link['link']))),
                                          );
                                      }));
                            },
                          style: TextStyle(
                              color: Colors.lightBlue,
                              decoration: TextDecoration.underline))
                      : TextSpan(text: '')
                ])),
          ),
        ),
        SizedBox(height: 200)
      ],
    );
  }

  doesContainLink(String text) {
    List<String> words = text.split(' ');
    print(words.toString());
    for (String word in words)
      if (isURL(word, {'allow_underscores': true}))
        return {'trueOrFalse': true, 'link': word};
    return {'trueOrFalse': false};
  }
}
