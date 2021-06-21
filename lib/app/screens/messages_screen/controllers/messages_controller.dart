import 'dart:convert';
import 'package:application/app/screens/messages_screen/repositories/messages_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:web_socket_channel/io.dart';
import 'package:application/app/models/event_ws.dart';
import 'package:application/app/models/helpdesk.dart';

class MessagesController {
  MessagesRepository messagesRepository;
  var channel = IOWebSocketChannel.connect(
      Uri.parse('ws://test-chat.blubots.com/ws/chat/marcos/'));
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  MessagesController({
    required this.messagesRepository,
    required this.flutterLocalNotificationsPlugin,
  }) {
    final initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  Future _showNotification(
      {required String message, required String uuid}) async {
    var androidDetails = AndroidNotificationDetails(
        "id", "Nova Mensagem", "Nova mensagem do aplicativo chat",
        importance: Importance.high);
    var iosDetails = IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await flutterLocalNotificationsPlugin.show(
        int.parse(uuid), "Chat", message, generalNotificationDetails);
  }

  Future<List<HelpDesk>> findAllHelpDesk() async {
    try {
      return messagesRepository.findAllHelpDesk();
    } catch (e) {
      return [];
    }
  }

  void listenWS(void Function() setState) {
    channel.stream.listen((event) async {
      EventWS eventWS = EventWS.fromJson(jsonDecode(event));
      print(eventWS.data!.toJson());
      if (eventWS.type == "new_message" && eventWS.data!.type == "received") {
        await _showNotification(message: eventWS.data!.message!, uuid: "0");
      }
      setState();
    });
  }
}
