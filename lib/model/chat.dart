class Chat {
  final int id;
  final int user_id;
  final String user_telegram_id;
  String chat_id;
  final String chat_type;
  String chat_username;
  String chat_title;
  String chat_description;
  String chat_main_color;
  String in_;
  bool is_vip;
  int expire_time;

  Chat(
    this.id,
    this.user_id,
    this.user_telegram_id,
    this.chat_id,
    this.chat_type,
    this.chat_username,
    this.chat_title,
    this.chat_description,
    this.chat_main_color,
    this.in_,
    this.is_vip,
    this.expire_time,
  );

  Chat.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        user_id = int.parse(json['user_id']),
        user_telegram_id = json['user_telegram_id'],
        chat_id = json['chat_id'],
        chat_type = json['chat_type'],
        chat_username = json['chat_username'],
        chat_title = json['chat_title'],
        chat_description = json['chat_description'],
        chat_main_color = json['chat_main_color'],
        in_ = json['in'],
        is_vip = json['is_vip'].toString() == "1" ? true : false,
        expire_time = json['expire_time'] as int;

//  Map<String, dynamic> toJson() => {
//        'id': id,
//        'group_id': group_id,
//        'path': path,
//        'size': size,
//        'created_at': created_at,
//        'link': link,
//      };
}
