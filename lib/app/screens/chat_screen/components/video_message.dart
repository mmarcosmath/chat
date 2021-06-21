import 'package:chewie/chewie.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

class VideoMessage extends StatelessWidget {
  final String videoPath;
  final bool isSent;
  final String status;
  final String date;
  VideoMessage({
    Key? key,
    required this.videoPath,
    required this.isSent,
    required this.date,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: isSent
            ? EdgeInsets.only(left: 30, top: 10, right: 5)
            : EdgeInsets.only(right: 30, top: 10, left: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSent
              ? Theme.of(context).primaryColor
              : Theme.of(context).backgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: 200,
              width: 150,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Align(
                alignment: Alignment.center,
                child: FloatingActionButton(
                  onPressed: () async {
                    VideoPlayerController _controller =
                        VideoPlayerController.network(videoPath);
                    await _controller.initialize();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Colors.black,
                            insetPadding: EdgeInsets.symmetric(
                              horizontal: 30,
                            ),
                            child: VideoPlayerMessage(
                              controller: _controller,
                            ),
                          );
                        });
                  },
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  date.substring(11, 16),
                  style: TextStyle(
                    fontSize: 12,
                    height: 1,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Visibility(
                  visible: isSent,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Icon(
                      status == "sending"
                          ? Icons.check_circle_outline_rounded
                          : Icons.check_circle_rounded,
                      color: DynamicTheme.of(context)!.themeId == 0
                          ? Colors.white.withOpacity(0.8)
                          : Colors.blueAccent,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerMessage extends StatefulWidget {
  final VideoPlayerController controller;

  VideoPlayerMessage({
    Key? key,
    required this.controller,
  }) : super(key: key);
  @override
  _VideoPlayerMessageState createState() => _VideoPlayerMessageState();
}

class _VideoPlayerMessageState extends State<VideoPlayerMessage> {
  @override
  Widget build(BuildContext context) {
    final chewieController = ChewieController(
      videoPlayerController: widget.controller,
    );
    return Stack(
      children: [
        widget.controller.value.isInitialized
            ? Center(
                child: AspectRatio(
                  aspectRatio: widget.controller.value.aspectRatio,
                  child: Chewie(controller: chewieController),
                ),
              )
            : Container(),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
  }
}
