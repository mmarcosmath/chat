import 'dart:convert';

import 'package:application/app/models/message.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class ChatRepository {
  final _dio = Dio();

  Future<List<Message>> findHistoryHelpDesk(String uuid) async {
    try {
      var response = await _dio.get<List>(
        "http://test-chat.blubots.com/api/help-desks/$uuid/history",
      );
      return response.data!
          .map<Message>((resp) => Message.fromJson(resp))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<Map<dynamic, dynamic>> postMessage(String uuid, String message) async {
    try {
      var response = await _dio.postUri<Map>(
          Uri.http("test-chat.blubots.com", "/api/send-message/"),
          data: FormData.fromMap({"message": message, "help_desk": uuid}));
      Map responseMap = jsonDecode(response.toString());
      return responseMap;
    } catch (e) {
      return {};
    }
  }

  Future<Map<dynamic, dynamic>> postMessageAudio(
      String uuid, String message, String filePath) async {
    try {
      var response = await _dio.postUri<Map>(
          Uri.http("test-chat.blubots.com", "/api/send-message/"),
          data: FormData.fromMap(
            {
              "message": message,
              "help_desk": uuid,
              "file": await MultipartFile.fromFile(filePath,
                  filename: "audio.m4a",
                  contentType: MediaType("audio", "MPEG_4")),
              "type": "audio/MPEG_4"
            },
          ),
          options: Options(headers: {
            "accept": "*/*",
            "Content-Type": "multipart/form-data"
          }));
      Map responseMap = jsonDecode(response.toString());
      return responseMap;
    } catch (e) {
      return {};
    }
  }

  Future<Map<dynamic, dynamic>> postMessageFiles(
      String uuid, String message, String filePath, String extension) async {
    try {
      var response = await _dio.postUri<Map>(
          Uri.http("test-chat.blubots.com", "/api/send-message/"),
          data: FormData.fromMap(
            {
              "message": message,
              "help_desk": uuid,
              "file": await MultipartFile.fromFile(filePath,
                  filename: "$extension.$extension",
                  contentType: MediaType("image", "jpg")),
              "type": "image/$extension"
            },
          ),
          options: Options(headers: {
            "accept": "*/*",
            "Content-Type": "multipart/form-data"
          }));
      Map responseMap = jsonDecode(response.toString());
      return responseMap;
    } catch (e) {
      return {};
    }
  }
}
