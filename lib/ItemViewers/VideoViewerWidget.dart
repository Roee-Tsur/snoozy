import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:share/share.dart';
import 'package:snozzy/Pages/ItemViewerPage.dart';
import 'package:snozzy/models/VideoItem.dart';
import 'package:video_player/video_player.dart';

import '../Globals.dart';

class VideoViewerWidget extends StatefulWidget
    implements ItemViewerContentWidget {
  VideoItem videoItem;

  VideoViewerWidget(this.videoItem);

  @override
  _VideoViewerWidgetState createState() => new _VideoViewerWidgetState();

  @override
  List<PopupMenuItem> getPopupMenuButtons() {
    return [
      PopupMenuItem(
          child: TextButton(
        onPressed: () => OpenFile.open(videoItem.path),
        child: Row(
          children: [
            Icon(Icons.open_in_new, color: Globals.strongGray),
            SizedBox(width: 10),
            Text('Open in system default', style: TextStyle(color: Globals.textBlack)),
          ],
        ),
      )),
      PopupMenuItem(
          child: TextButton(
        onPressed: () => Share.shareFiles([videoItem.path]),
        child: Row(
          children: [
            Icon(Icons.share_outlined, color: Globals.strongGray),
            SizedBox(width: 10),
            Text('Share video', style: TextStyle(color: Globals.textBlack)),
          ],
        ),
      ))
    ];
  }
}

class _VideoViewerWidgetState extends State<VideoViewerWidget> {
  late FlickManager flickManager;

  @override
  initState() {
    super.initState();
    flickManager = FlickManager(
        autoPlay: false,
        videoPlayerController:
            VideoPlayerController.file(File(widget.videoItem.path)));
  }

  @override
  void dispose() {
    super.dispose();
    flickManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FlickPortraitControls controls = FlickPortraitControls(
      iconSize: 20,
      fontSize: 18,
    );

    return Scaffold(
      body: FlickVideoPlayer(
        flickManager: flickManager,
        flickVideoWithControls: FlickVideoWithControls(
          controls: controls,
        ),
        flickVideoWithControlsFullscreen:
            FlickVideoWithControls(controls: controls),
      ),
    );
  }
}
