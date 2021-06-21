import 'dart:async';
import 'dart:io';
import 'package:application/app/screens/chat_screen/components/video_message.dart';
import 'package:application/app/screens/chat_screen/controllers/chat_controller.dart';
import 'package:application/app/screens/chat_screen/repositories/chat_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:application/app/models/message.dart';
import 'package:application/app/screens/chat_screen/components/attach_files.dart';
import 'package:application/app/screens/chat_screen/components/image_message.dart';
import 'package:application/app/screens/chat_screen/components/text_message.dart';

import 'components/audio_message.dart';

class ChatScreen extends StatefulWidget {
  final String uuid;
  final String name;
  final String image;
  ChatScreen({
    Key? key,
    required this.uuid,
    required this.name,
    required this.image,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatController chatController = ChatController(
    chatRepository: ChatRepository(),
  );
  var controllerTextField = TextEditingController();
  var filePath = "";
  var isRecorder = false;
  var isMessage = false;
  var isAttach = true;
  int durationAudio = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    chatController.listenWS(() {
      setState(() {});
    });
  }

  void durationAtt() {
    setState(() {
      durationAudio += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget typeMessage(Message message) {
      if (message.file != null && message.file!.contains(".mp4")) {
        return VideoMessage(
          isSent: message.type == "sent" ? true : false,
          videoPath: message.file ?? "",
          date: message.createdAt ?? "",
          status: message.status ?? "",
        );
      }
      if (message.file != null &&
          (message.file!.contains(".m4a") || message.file!.contains(".mp3"))) {
        return AudioMessage(
          durationAudio: 10,
          isSent: message.type == "sent" ? true : false,
          audioFile: message.file ?? "",
          date: message.createdAt ?? "",
          status: message.status ?? "",
        );
      }

      if (message.file != null &&
          (message.file!.contains(".jpg") ||
              message.file!.contains(".jpeg") ||
              message.file!.contains(".png"))) {
        return ImageMessage(
          isSent: message.type == "sent" ? true : false,
          imagePath: message.file ?? "",
          date: message.createdAt ?? "",
          status: message.status ?? "",
        );
      }
      return TextMessage(
        isSent: message.type == "sent" ? true : false,
        message: message.message ?? "",
        file: message.file ?? "",
        date: message.createdAt ?? "",
        status: message.status ?? "",
      );
    }

    void sendMessageFiles(message) {
      message.addAll({"uuid": widget.uuid});
      chatController.addMessage(message);

      setState(() {
        Future.delayed(Duration(milliseconds: 200), () {
          setState(() {
            chatController.scrollController.jumpTo(0);
          });
        });
      });
    }

    void sendMessageText() {
      if (controllerTextField.text.isNotEmpty)
        setState(() async {
          await chatController.chatRepository
              .postMessage(widget.uuid, controllerTextField.text);
          controllerTextField.clear();
          isAttach = true;
        });
    }

    void stopRecord() async {
      await Record.stop();
      await chatController.chatRepository
          .postMessageAudio(widget.uuid, "audio", filePath);
      setState(() {
        isAttach = true;
        isRecorder = false;
        durationAudio = 0;
        timer!.cancel();

        // messages.add({
        //   "audio_file": filePath,
        //   "duration_audio": meta.trackDuration
        // });
      });

      // var retriever = new MetadataRetriever();
      // retriever.setFile(File(filePath)).then((value) {
      //   retriever.metadata.then((meta) {
      //     print(meta.trackDuration);
      //   });
      // });
    }

    Future<void> startRecord(_) async {
      var fileName = DateTime.now().day.toString() +
          DateTime.now().month.toString() +
          DateTime.now().year.toString() +
          DateTime.now().hour.toString() +
          DateTime.now().minute.toString() +
          DateTime.now().second.toString() +
          DateTime.now().millisecond.toString();

      Directory? appDirectory = await getExternalStorageDirectory();
      filePath = '${appDirectory!.path}/$fileName.m4a';
      if (await Record.hasPermission()) {
        timer = Timer.periodic(
          Duration(seconds: 1),
          (timer) {
            durationAtt();
          },
        );
        setState(() {
          isAttach = false;
          isRecorder = true;
        });
        Vibration.hasVibrator().then((value) {
          if (value!) {
            Vibration.vibrate();
          }
        });

        await Record.start(
          path: '$filePath',
          encoder: AudioEncoder.AAC,
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: AppBar().preferredSize.height,
              padding: EdgeInsets.only(top: 5, bottom: 5, right: 10),
              child: ClipOval(
                child: Image.network(
                  widget.image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Text(
              widget.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 16,
                height: 1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    controller: chatController.scrollController,
                    reverse: true,
                    child: FutureBuilder(
                        future: chatController.chatRepository
                            .findHistoryHelpDesk(widget.uuid),
                        builder:
                            (context, AsyncSnapshot<List<Message>> snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                                children: snapshot.data!.reversed
                                    .map((message) => typeMessage(message))
                                    .toList());
                          }
                          return Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              height: AppBar().preferredSize.height,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: AppBar().preferredSize.height,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Theme.of(context).primaryColor),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              onChanged: (message) {
                                if (message.isNotEmpty)
                                  setState(() {
                                    isAttach = false;
                                  });
                                else
                                  setState(() {
                                    isAttach = true;
                                  });
                              },
                              controller: controllerTextField,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                              onFieldSubmitted: (message) {
                                if (message.isNotEmpty)
                                  setState(() async {
                                    await chatController.chatRepository
                                        .postMessage(widget.uuid,
                                            controllerTextField.text);
                                    controllerTextField.clear();
                                    isAttach = true;
                                  });
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                isCollapsed: true,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: isAttach,
                            child: AttachFiles(
                              addMessage: sendMessageFiles,
                            ),
                            replacement: Visibility(
                              visible: isRecorder,
                              child: Text(
                                Duration(
                                  minutes: 0,
                                  seconds: durationAudio,
                                  milliseconds: 0,
                                ).toString().substring(2, 7),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onLongPressStart: startRecord,
                    onLongPressUp: stopRecord,
                    onTap: sendMessageText,
                    child: Container(
                      height: AppBar().preferredSize.height,
                      width: AppBar().preferredSize.height,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Icon(
                        isAttach ? Icons.mic : Icons.send_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
