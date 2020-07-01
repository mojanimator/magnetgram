class Divar {
  final int id;
  final int user_id;
  final String chat_id;
  final String chat_type;
  final String chat_username;
  final String chat_title;
  final String chat_description;
  final String chat_main_color;

  final String role;
  final bool is_vip;
  int expire_time;
  final int start_time;

  Divar(
      this.id,
      this.user_id,
      this.chat_id,
      this.chat_type,
      this.chat_username,
      this.chat_title,
      this.chat_description,
      this.chat_main_color,
      this.role,
      this.is_vip,
      this.expire_time,
      this.start_time);

  Divar.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        user_id = int.parse(json['user_id']),
        chat_id = json['chat_id'],
        chat_type = json['chat_type'],
        chat_username = json['chat_username'],
        chat_title = json['chat_title'],
        chat_description = json['chat_description'],
        chat_main_color = json['chat_main_color'],
        role = json['role'],
        is_vip = json['is_vip'] == "1" ? true : false,
        expire_time = json['expire_time'] as int,
        start_time = json['start_time'] as int;

//  Map<String, dynamic> toJson() => {
//        'id': id,
//        'group_id': group_id,
//        'path': path,
//        'size': size,
//        'created_at': created_at,
//        'link': link,
//      };
}
