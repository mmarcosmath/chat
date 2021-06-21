import 'package:application/app/models/message.dart';

class EventWS {
  String? type;
  Message? data;

  EventWS({this.type, this.data});

  EventWS.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = json['data'] != null ? new Message.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
