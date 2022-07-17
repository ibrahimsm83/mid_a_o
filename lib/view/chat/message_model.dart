// class ChatModelData {
//   String? userName;
//   String? userImage;
//   int? chatId;
//   int? chatSenderId;
//   int? chatRecieverId;
//   String? chatGroupId;
//   String? chatMessage;
//   String? createdAt;

//   ChatModelData({
//     this.userName,
//     this.userImage,
//     this.chatId,
//     this.chatSenderId,
//     this.chatRecieverId,
//     this.chatGroupId,
//     this.chatMessage,
//     this.createdAt,
//   });
//   ChatModelData.fromJson(Map<String, dynamic> json) {
//     userName = json['user_name']?.toString();
//     userImage = json['user_image']?.toString();
//     chatId = json['chat_id']?.toInt();
//     chatSenderId = json['chat_sender_id']?.toInt();
//     chatRecieverId = json['chat_reciever_id']?.toInt();
//     chatGroupId = json['chat_group_id']?.toString();
//     chatMessage = json['chat_message']?.toString();
//     createdAt = json['created_at']?.toString();
//   }
//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['user_name'] = userName;
//     data['user_image'] = userImage;
//     data['chat_id'] = chatId;
//     data['chat_sender_id'] = chatSenderId;
//     data['chat_reciever_id'] = chatRecieverId;
//     data['chat_group_id'] = chatGroupId;
//     data['chat_message'] = chatMessage;
//     data['created_at'] = createdAt;
//     return data;
//   }
// }

// class ChatModel {
//   String? objectType;
//   List<ChatModelData?>? data;

//   ChatModel({
//     this.objectType,
//     this.data,
//   });
//   ChatModel.fromJson(Map<String, dynamic> json) {
//     objectType = json['object_type']?.toString();
//     if (json['data'] != null) {
//       final v = json['data'];
//       final arr0 = <ChatModelData>[];
//       v.forEach((v) {
//         arr0.add(ChatModelData.fromJson(v));
//       });
//       this.data = arr0;
//     }
//   }
//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['object_type'] = objectType;
//     if (this.data != null) {
//       final v = this.data;
//       final arr0 = [];
//       v!.forEach((v) {
//         arr0.add(v!.toJson());
//       });
//       data['data'] = arr0;
//     }
//     return data;
//   }
// }
