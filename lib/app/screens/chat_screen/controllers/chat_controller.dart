import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

import 'package:application/app/models/message.dart';
import 'package:application/app/screens/chat_screen/repositories/chat_repository.dart';

class ChatController {
  ChatRepository chatRepository;
  var channel = IOWebSocketChannel.connect(
      Uri.parse('ws://test-chat.blubots.com/ws/chat/marcos/'));
  var scrollController = ScrollController();
  ChatController({
    required this.chatRepository,
  });

  void listenWS(void Function() setState) {
    var channel = IOWebSocketChannel.connect(
        Uri.parse('ws://test-chat.blubots.com/ws/chat/marcos/'));
    channel.stream.listen((event) async {
      setState();
    });
  }

  void addMessage(Map<String, dynamic> message) async {
    if (message.containsKey("image")) {
      await chatRepository.postMessageFiles(
        message["uuid"],
        "image",
        message["image"],
        message["extension"],
      );
    }
    if (message.containsKey("video")) {
      await chatRepository.postMessageFiles(
        message["uuid"],
        "video",
        message["video"],
        message["extension"],
      );
    }
    if (message.containsKey("pdf")) {
      await chatRepository.postMessageFiles(
        message["uuid"],
        "pdf",
        message["pdf"],
        message["extension"],
      );
    }
    if (message.containsKey("doc")) {
      await chatRepository.postMessageFiles(
        message["uuid"],
        "doc",
        message["doc"],
        message["extension"],
      );
    }
    if (message.containsKey("docx")) {
      await chatRepository.postMessageFiles(
        message["uuid"],
        "docx",
        message["docx"],
        message["extension"],
      );
    }
    if (message.containsKey("mp3")) {
      await chatRepository.postMessageFiles(
        message["uuid"],
        "mp3",
        message["mp3"],
        message["extension"],
      );
    }
  }

  Future<List<Message>> findHistoryHelpDesk(String uuid) async {
    try {
      return chatRepository.findHistoryHelpDesk(uuid);
    } catch (e) {
      return [];
    }
  }

  Future<Map<dynamic, dynamic>> postMessage(String uuid, String message) async {
    try {
      return chatRepository.postMessage(uuid, message);
    } catch (e) {
      return {};
    }
  }

  Future<Map<dynamic, dynamic>> postMessageAudio(
      String uuid, String message, String filePath) async {
    try {
      return chatRepository.postMessageAudio(uuid, message, filePath);
    } catch (e) {
      return {};
    }
  }

  Future<Map<dynamic, dynamic>> postMessageFiles(
      String uuid, String message, String filePath, String extension) async {
    try {
      return chatRepository.postMessageFiles(
          uuid, message, filePath, extension);
    } catch (e) {
      return {};
    }
  }
}
