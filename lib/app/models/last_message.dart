// class LastMessage {
//   String? createdAt;
//   String? updatedAt;
//   String? uuid;
//   String? message;
//   String? file;
//   String? type;
//   String? status;
//   String? helpDesk;

//   LastMessage(
//       {this.createdAt,
//       this.updatedAt,
//       this.uuid,
//       this.message,
//       this.file,
//       this.type,
//       this.status,
//       this.helpDesk});

//   LastMessage.fromJson(Map<String, dynamic> json) {
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     uuid = json['uuid'];
//     message = json['message'];
//     file = json['file'];
//     type = json['type'];
//     status = json['status'];
//     helpDesk = json['help_desk'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['uuid'] = this.uuid;
//     data['message'] = this.message;
//     data['file'] = this.file;
//     data['type'] = this.type;
//     data['status'] = this.status;
//     data['help_desk'] = this.helpDesk;
//     return data;
//   }
// }
