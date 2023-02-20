class UserModel {
  String id;
  String firstName;
  String lastName;
  String email;
  String? avatarUrl;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatarUrl,
  }); // Challenge constructor that initializes the class fields

  factory UserModel.fromJson(String id, Map<String, dynamic> json) => UserModel(
    id: id,
    firstName: json['firstName'],
    lastName: json['lastName'],
    email: json['email'],
    avatarUrl: json["avatarUrl"],
  );
}
