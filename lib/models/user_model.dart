class UserModel {
  final int? status;
  final String? message;
  final UserData? data;
  final String? bearerToken;
  UserModel({this.status, this.message, this.data, this.bearerToken});

  UserModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as int?,
        message = json['message'] as String?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? UserData.fromJson(json['data'] as Map<String, dynamic>)
            : null,
        bearerToken = json['bearer_token'] as String?;
  Map<String, dynamic> toJson() => {
        // final _data = <String, dynamic>{};
        'status': status,
        'message': message,
        'data': data?.toJson(),
        'bearer_token': bearerToken,
        // return _data;
      };
}

class UserData {
  late final int? id;
  late final String? username;
  late final String? profileComplete;
  late final String? image;
  late final String? email;
  UserData(
      {this.id, this.username, this.profileComplete, this.image, this.email});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    profileComplete = null;
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['username'] = username;
    _data['profile_complete'] = profileComplete;
    _data['image'] = image;
    _data['email'] = email;
    return _data;
  }
}

// class BearerToken {
//   BearerToken({
//     required this.name,
//     required this.abilities,
//     required this.tokenableId,
//     required this.tokenableType,
//     required this.updatedAt,
//     required this.createdAt,
//     required this.id,
//   });
//   late final String name;
//   late final List<String> abilities;
//   late final int tokenableId;
//   late final String tokenableType;
//   late final String updatedAt;
//   late final String createdAt;
//   late final int id;

//   BearerToken.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     abilities = List.castFrom<dynamic, String>(json['abilities']);
//     tokenableId = json['tokenable_id'];
//     tokenableType = json['tokenable_type'];
//     updatedAt = json['updated_at'];
//     createdAt = json['created_at'];
//     id = json['id'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['name'] = name;
//     _data['abilities'] = abilities;
//     _data['tokenable_id'] = tokenableId;
//     _data['tokenable_type'] = tokenableType;
//     _data['updated_at'] = updatedAt;
//     _data['created_at'] = createdAt;
//     _data['id'] = id;
//     return _data;
//   }
// }
