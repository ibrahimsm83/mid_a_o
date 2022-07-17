class EventModel {
  EventModel({
    required this.status,
    required this.data,
  });
  late final int status;
  late final List<EventData> data;

  EventModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = List.from(json['data']).map((e) => EventData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class EventData {
  EventData({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    this.image,
    required this.description,
    required this.address,
    required this.createdAt,
    required this.images,
    required this.sub,
    required this.comments,
  });
  late final int id;
  late final String title;
  late final String date;
  late final String time;
  late final String? image;
  late final String description;
  late final String address;
  late final String createdAt;
  late final List<String> images;
  late final List<Sub> sub;
  late final List<Comments> comments;

  EventData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    date = json['date'];
    time = json['time'];
    image = json['image'];
    description = json['description'];
    address = json['address'];
    createdAt = json['created_at'];
    images = List.castFrom<dynamic, String>(json['images']);
    sub = List.from(json['sub']).map((e) => Sub.fromJson(e)).toList();
    comments =
        List.from(json['comments']).map((e) => Comments.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['date'] = date;
    _data['time'] = time;
    _data['image'] = image;
    _data['description'] = description;
    _data['address'] = address;
    _data['created_at'] = createdAt;
    _data['images'] = images;
    _data['sub'] = sub.map((e) => e.toJson()).toList();
    _data['comments'] = comments.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Sub {
  Sub({
    required this.title,
    required this.date,
    required this.time,
    required this.dateTime,
  });
  late final String title;
  late final String date;
  late final String time;
  late final String dateTime;

  Sub.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    date = json['date'];
    time = json['time'];
    dateTime = json['date_time'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['date'] = date;
    _data['time'] = time;
    _data['date_time'] = dateTime;
    return _data;
  }
}

class Comments {
  Comments({
    required this.id,
    required this.comment,
    required this.rating,
    required this.images,
    required this.userName,
    required this.userImage,
  });
  late final int id;
  late final String comment;
  late final int rating;
  late final List<String> images;
  late final String userName;
  late final String userImage;

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    rating = json['rating'];
    images = List.castFrom<dynamic, String>(json['images']);
    userName = json['user_name'];
    userImage = json['user_image'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['comment'] = comment;
    _data['rating'] = rating;
    _data['images'] = images;
    _data['user_name'] = userName;
    _data['user_image'] = userImage;
    return _data;
  }
}



// class EventModel {
//   EventModel({
//     required this.status,
//     required this.data,
//   });
//   late final int status;
//   late final List<EventData> data;

//   EventModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     data = List.from(json['data']).map((e) => EventData.fromJson(e)).toList();
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['status'] = status;
//     _data['data'] = data.map((e) => e.toJson()).toList();
//     return _data;
//   }
// }

// class EventData {
//   EventData({
//     required this.id,
//     required this.title,
//     required this.date,
//     required this.time,
//     this.image,
//     required this.description,
//     required this.address,
//     required this.images,
//     required this.createdate,
//     required this.sub,
//     required this.comments,
//   });
//   late final int id;
//   late final String title;
//   late final String date;
//   late final String time;
//   late final String address;
//   late final String createdate;
//   late final String? image;
//   late final String description;
//   late final List<Images> images;
//   late final List<Sub> sub;
//   late final List<Comments> comments;

//   EventData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     date = json['date'];
//     time = json['time'];
//     createdate = json['created_at'];
//     address = json['address'];
//     image = json['image'];
//     description = json['description'];
//     images = List.from(json['images']).map((e) => Images.fromJson(e)).toList();
//     sub = List.from(json['sub']).map((e) => Sub.fromJson(e)).toList();
//     comments =
//         List.from(json['comments']).map((e) => Comments.fromJson(e)).toList();
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['id'] = id;
//     _data['title'] = title;
//     _data['date'] = date;
//     _data['time'] = time;
//     _data['created_at'] = createdate;
//     _data['image'] = image;
//     _data['address'] = address;
//     _data['description'] = description;
//     _data['images'] = images.map((e) => e.toJson()).toList();
//     _data['sub'] = sub.map((e) => e.toJson()).toList();
//     _data['comments'] = comments.map((e) => e.toJson()).toList();
//     return _data;
//   }
// }

// class Images {
//   Images({
//     required this.id,
//     required this.url,
//   });
//   late final int id;
//   late final String url;

//   Images.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     url = json['url'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['id'] = id;
//     _data['url'] = url;
//     return _data;
//   }
// }

// class Sub {
//   Sub({
//     required this.title,
//     required this.date,
//     required this.time,
//     required this.datetime,
//   });
//   late final String title;
//   late final String date;
//   late final String time;
//   late final String datetime;

//   Sub.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     date = json['date'];
//     time = json['time'];
//     datetime = json['date_time'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['title'] = title;
//     _data['date'] = date;
//     _data['time'] = time;
//     _data['date_time'] = datetime;
//     return _data;
//   }
// }

// class Comments {
//   Comments({
//     required this.id,
//     required this.comment,
//     required this.rating,
//     required this.images,
//     required this.userName,
//     required this.userImage,
//   });
//   late final int id;
//   late final String comment;
//   late final int rating;
//   late final List<Images> images;
//   late final String userName;
//   late final String userImage;

//   Comments.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     comment = json['comment'];
//     rating = json['rating'];
//     images = List.from(json['images']).map((e) => Images.fromJson(e)).toList();
//     userName = json['user_name'];
//     userImage = json['user_image'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['id'] = id;
//     _data['comment'] = comment;
//     _data['rating'] = rating;
//     _data['images'] = images.map((e) => e.toJson()).toList();
//     _data['user_name'] = userName;
//     _data['user_image'] = userImage;
//     return _data;
//   }
// }
