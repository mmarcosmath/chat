import 'dart:convert';

import 'package:application/app/models/helpdesk.dart';
import 'package:dio/dio.dart';

class MessagesRepository {
  final _dio = Dio();

  Future<List<HelpDesk>> findAllHelpDesk() async {
    try {
      var response = await _dio.get<List>(
          "http://test-chat.blubots.com/api/help-desks",
          queryParameters: {"organization": "marcos"});

      return response.data!
          .map<HelpDesk>((resp) => HelpDesk.fromJson(resp))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
