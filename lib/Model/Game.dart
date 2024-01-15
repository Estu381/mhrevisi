class GameData {
  String? id;
  String? image;
  String? headline;
  String? content;
  String? userId;
  String? status;

  GameData({
    this.id,
    this.image,
    this.headline,
    this.content,
    this.userId,
    this.status,
  });

  // Factory method to create a GameData object from a JSON map.
  factory GameData.fromJson(Map<String, dynamic> json) {
    return GameData(
      id: json['id'],
      image: json['image'],
      headline: json['headline'],
      content: json['content'],
      userId: json['user_id'],
      status: json['status'],
    );
  }

  // Method to convert the GameData object to a JSON map for serialization.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['headline'] = this.headline;
    data['content'] = this.content;
    data['user_id'] = this.userId;
    data['status'] = this.status;
    return data;
  }
}
