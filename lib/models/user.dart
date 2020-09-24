class User {
  final int id;
  final String first_name;
  final String last_name;
  final String email;
  final String username;
  final String phone;
  final String birth_date;
  final String gender;
  final String avatar;
  final String patronymic;

  User({
    this.id,
    this.first_name,
    this.last_name,
    this.email,
    this.username,
    this.phone,
    this.birth_date,
    this.gender,
    this.avatar,
    this.patronymic,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      phone: json['phone'] as String,
      birth_date: json['birth_date'] as String,
      gender: json['gender'] as String,
      avatar: json['avatar'] as String,
      patronymic: json['patronymic'] as String,
    );
  }
}
