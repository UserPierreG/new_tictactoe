// ignore_for_file: file_names

class Player {
  final String nickname;

  Player({
    required this.nickname,
  });

  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      nickname: map['nickname'],
    );
  }
}
