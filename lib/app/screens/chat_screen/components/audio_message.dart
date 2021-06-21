import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AudioMessage extends StatefulWidget {
  final String audioFile;
  final int durationAudio;
  final String status;
  final bool isSent;
  final String date;
  AudioMessage({
    Key? key,
    required this.audioFile,
    required this.durationAudio,
    required this.isSent,
    required this.date,
    required this.status,
  }) : super(key: key);

  @override
  _AudioMessageState createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  AudioPlayer audioPlayer = AudioPlayer();
  // OcarinaPlayer? player;
  @override
  void dispose() {
    super.dispose();
    // player!.dispose();
    audioPlayer.dispose();
  }

  @override
  void initState() {
    super.initState();

    // player = OcarinaPlayer(
    //   filePath: '${widget.audioFile}',
    //   loop: false,
    //   volume: 0.8,
    // );
    // player!.load();
  }

  Timer? timer;
  bool isPlayer = false;
  double position = 0.0;
  Duration duration = Duration();
  @override
  Widget build(BuildContext context) {
    Future<void> playerPosition() async {
      var positionAudio = await audioPlayer.getCurrentPosition();
      setState(() {
        position = positionAudio.toDouble();
      });

      // if (player!.isLoaded() && isPlayer) {
      //   var positionAudio = await player!.position();
      //   setState(() {
      //     position = positionAudio.toDouble();
      //   });

      //   if (position >= widget.durationAudio) {
      //     timer!.cancel();
      //     setState(() {
      //       if (player!.isLoaded()) player!.stop();
      //       position = 0;
      //       isPlayer = false;
      //     });
      //   }
      // }
    }

    return Align(
      alignment: widget.isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: isPlayer
            ? () async {
                await audioPlayer.stop();
                setState(() {
                  isPlayer = false;
                });
                timer!.cancel();
                // if (player!.isLoaded()) await player!.stop();
                // setState(() {
                //   isPlayer = false;
                //   timer!.cancel();
                // });
              }
            : () async {
                int result = await audioPlayer.play(widget.audioFile);
                if (result == 1) {
                  duration = await audioPlayer.onDurationChanged.first;
                  audioPlayer.onDurationChanged.listen((event) {
                    audioPlayer.onPlayerStateChanged.listen((PlayerState e) {
                      print(e.index.toString());
                      if (e.index == 3) {
                        setState(() {
                          timer!.cancel();
                          isPlayer = false;
                        });
                      }
                    });

                    isPlayer = true;
                    timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
                      playerPosition();
                      print(Duration(milliseconds: position.toInt()));
                    });
                    // player!.play();
                  });
                }
              },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              margin: widget.isSent
                  ? EdgeInsets.only(left: 30, top: 10, right: 5)
                  : EdgeInsets.only(right: 30, top: 10, left: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: widget.isSent
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).backgroundColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        isPlayer ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 30,
                      ),
                      Expanded(
                        child: Slider(
                          // value: position % widget.durationAudio,
                          value: position,
                          min: 0,
                          max: duration.inMilliseconds.toDouble(),
                          onChanged: (value) {},
                          activeColor: Colors.white,
                        ),
                      ),
                      Text(
                        Duration(milliseconds: position.toInt())
                            .toString()
                            .substring(2, 7),
                        style: TextStyle(
                          fontSize: 14,
                          height: 1,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.date.substring(11, 16),
                        style: TextStyle(
                          fontSize: 12,
                          height: 1,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      Visibility(
                        visible: widget.isSent,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(
                            widget.status == "sending"
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
          ],
        ),
      ),
    );
  }
}
