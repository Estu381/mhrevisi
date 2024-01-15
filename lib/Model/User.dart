class UserData {
  String? id; // Unique identifier for the user.
  String? username; // Username of the user.
  String? password; // Password of the user.

  // Constructor for creating a UserData object.
  UserData({
    this.id,
    this.username,
    this.password,
  });

  // Factory method to create a UserData object from a JSON map.
  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
  }

  // Method to convert the UserData object to a JSON map for serialization.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['password'] = this.password;
    return data;
  }
}
