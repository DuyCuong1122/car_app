class UserDB {
  final String? id;
  final String? username;
  final String? email;
  final List<String>? roles;
  final String? access_token;
  final String? displayName;

  UserDB({
    this.id,
    this.username,
    this.email,
    this.roles,
    this.access_token,
    this.displayName,
  });

  factory UserDB.fromJson(Map<String, dynamic> json) {
    // Xử lý trường 'roles' để đảm bảo rằng nó là một danh sách
    List<String> roles = [];
    if (json['roles'] is String) {
      // Nếu 'roles' là một chuỗi, bạn có thể tách nó thành danh sách bằng dấu phân cách, giả sử là dấu phẩy
      roles = (json['roles'] as String)
          .split(',')
          .map((role) => role.trim())
          .toList();
    } else if (json['roles'] is List) {
      // Nếu 'roles' là một danh sách, bạn cần đảm bảo rằng mỗi phần tử là một chuỗi
      roles = List<String>.from(json['roles']);
    }

    return UserDB(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      roles: roles,
      access_token: json["access_token"],
      displayName: json["displayName"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'roles': roles,
      'access_token': access_token,
      'displayName': displayName,
    };
  }
}
