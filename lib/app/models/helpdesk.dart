import 'package:application/app/models/client.dart';
import 'package:application/app/models/last_message.dart';
import 'package:application/app/models/message.dart';

class HelpDesk {
  late String createdAt;
  late String updatedAt;
  late String uuid;
  Client? client;
  Message? lastMessage;

  HelpDesk({
    this.createdAt = "",
    this.updatedAt = "",
    this.uuid = "",
    this.client,
    this.lastMessage,
  });

  HelpDesk.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    uuid = json['uuid'] ?? "";
    client =
        json['client'] != null ? new Client.fromJson(json['client']) : null;
    lastMessage = json['last_message'] != null
        ? new Message.fromJson(json['last_message'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['uuid'] = this.uuid;
    if (this.client != null) {
      data['client'] = this.client!.toJson();
    }
    if (this.lastMessage != null) {
      data['last_message'] = this.lastMessage!.toJson();
    }
    return data;
  }
}
