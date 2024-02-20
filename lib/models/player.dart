// ignore_for_file: file_names

class Player {
  String nickname;
  String playerType;
  int points;

  Player({
    required this.nickname,
    required this.playerType,
    this.points = 0, // default value for points
  });

  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'playerType': playerType,
      'points': points,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      nickname: map['nickname'],
      playerType: map['playerType'],
      points: map['points'],
    );
  }
}
