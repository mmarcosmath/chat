import 'package:application/app/models/helpdesk.dart';
import 'package:application/app/screens/messages_screen/controllers/messages_controller.dart';
import 'package:application/app/screens/messages_screen/repositories/messages_repository.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'components/custom_list_tile.dart';

class MessagesScreen extends StatefulWidget {
  MessagesScreen({Key? key}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  MessagesController messagesController = MessagesController(
    messagesRepository: MessagesRepository(),
    flutterLocalNotificationsPlugin: FlutterLocalNotificationsPlugin(),
  );

  @override
  void initState() {
    super.initState();
    messagesController.listenWS(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() async {
            await DynamicTheme.of(context)!
                .setTheme(DynamicTheme.of(context)!.themeId == 0 ? 1 : 0);
          });
        },
        child: Icon(DynamicTheme.of(context)!.themeId == 0
            ? CupertinoIcons.moon
            : CupertinoIcons.sun_max),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: messagesController.messagesRepository.findAllHelpDesk(),
              builder: (context, AsyncSnapshot<List<HelpDesk>> snapshot) {
                if (snapshot.hasData) {
                  snapshot.data!.sort((a, b) => b.lastMessage!.updatedAt!
                      .compareTo(a.lastMessage!.updatedAt!));
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: snapshot.data!
                        .map(
                          (helpDeskItem) => CustomListTile(
                            image:
                                "https://avatars.githubusercontent.com/u/61097887?v=4",
                            name: helpDeskItem.client!.name!,
                            lastMessage:
                                helpDeskItem.lastMessage!.message != null
                                    ? helpDeskItem.lastMessage!.message!
                                    : "",
                            date: helpDeskItem.lastMessage!.updatedAt!
                                .substring(11, 16),
                            hasMessage:
                                helpDeskItem.lastMessage!.message == null
                                    ? false
                                    : true,
                            uuid: helpDeskItem.uuid,
                          ),
                        )
                        .toList(),
                  );
                }
                return Center(
                    child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ));
              }),
        ),
      ),
    );
  }
}
