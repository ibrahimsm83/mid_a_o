///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class SendMessageModelData {
/*
{
  "user_name": null,
  "image": null,
  "id": 42,
  "sender_id": 14,
  "reciever_id": null,
  "message": "hello ubaid",
  "created_at": "2022-04-18T08:19:26.000Z",
  "updated_at": null
} 
*/

  String? userName;
  String? image;
  int? id;
  int? senderId;
  String? recieverId;
  String? message;
  String? createdAt;
  String? updatedAt;

  SendMessageModelData({
    this.userName,
    this.image,
    this.id,
    this.senderId,
    this.recieverId,
    this.message,
    this.createdAt,
    this.updatedAt,
  });
  SendMessageModelData.fromJson(Map<String, dynamic> json) {
    userName = json['user_name']?.toString();
    image = json['image']?.toString();
    id = json['id']?.toInt();
    senderId = json['sender_id']?.toInt();
    recieverId = json['reciever_id']?.toString();
    message = json['message']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user_name'] = userName;
    data['image'] = image;
    data['id'] = id;
    data['sender_id'] = senderId;
    data['reciever_id'] = recieverId;
    data['message'] = message;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class SendMessageModel {
/*
{
  "object_type": "send_location",
  "data": [
    {
      "user_name": null,
      "image": null,
      "id": 42,
      "sender_id": 14,
      "reciever_id": null,
      "message": "hello ubaid",
      "created_at": "2022-04-18T08:19:26.000Z",
      "updated_at": null
    }
  ]
} 
*/

  String? objectType;
  List<SendMessageModelData?>? data;

  SendMessageModel({
    this.objectType,
    this.data,
  });
  SendMessageModel.fromJson(Map<String, dynamic> json) {
    objectType = json['object_type']?.toString();
    if (json['data'] != null) {
      final v = json['data'];
      final arr0 = <SendMessageModelData>[];
      v.forEach((v) {
        arr0.add(SendMessageModelData.fromJson(v));
      });
      this.data = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['object_type'] = objectType;
    if (this.data != null) {
      final v = this.data;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['data'] = arr0;
    }
    return data;
  }
}
