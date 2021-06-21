class Client {
  String? id;
  String? createdAt;
  String? name;
  String? phone;
  String? updatedAt;
  String? uuid;

  Client(
      {this.id,
      this.createdAt,
      this.name,
      this.phone,
      this.updatedAt,
      this.uuid});

  Client.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    name = json['name'];
    phone = json['phone'];
    updatedAt = json['updated_at'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['updated_at'] = this.updatedAt;
    data['uuid'] = this.uuid;
    return data;
  }
}
