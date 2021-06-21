class Message {
  String? id;
  String? helpDesk;
  String? createdAt;
  String? file;
  String? message;
  String? status;
  String? type;
  String? updatedAt;
  String? uuid;

  Message(
      {this.id,
      this.helpDesk,
      this.createdAt,
      this.file,
      this.message,
      this.status,
      this.type,
      this.updatedAt,
      this.uuid});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    helpDesk = json['help_desk'];
    createdAt = json['created_at'];
    file = json['file'];
    message = json['message'];
    status = json['status'];
    type = json['type'];
    updatedAt = json['updated_at'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['help_desk'] = this.helpDesk;
    data['created_at'] = this.createdAt;
    data['file'] = this.file;
    data['message'] = this.message;
    data['status'] = this.status;
    data['type'] = this.type;
    data['updated_at'] = this.updatedAt;
    data['uuid'] = this.uuid;
    return data;
  }
}
