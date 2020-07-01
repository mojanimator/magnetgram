class User {
  final int id;
  final String name;
  final String telegram_username;
  final String telegram_id;
  final String img;
  final String role;
  final List<dynamic> channels;
  final List<dynamic> groups;
  int score;

  User(this.id, this.name, this.telegram_username, this.telegram_id, this.img,
      this.role, this.channels, this.groups, this.score);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'],
        telegram_username = json['telegram_username'],
        telegram_id = json['telegram_id'],
        img = json['img'],
        role = json['role'],
        channels = json['channels'],
        groups = json['groups'],
        score = json['score'];

  User.nullUser()
      : id = null,
        name = null,
        telegram_username = null,
        telegram_id = null,
        img = null,
        role = null,
        channels = null,
        groups = null,
        score = 0;

//  Map<String, dynamic> toJson() => {
//        'id': id,
//        'group_id': group_id,
//        'path': path,
//        'size': size,
//        'created_at': created_at,
//        'link': link,
//      };
}
