class UserModel {
  String id;
  String name;

  UserModel({
    required this.id,
    required this.name,
  }); // Challenge constructor that initializes the class fields

  factory UserModel.fromJson(String id, Map<String, dynamic> json) => UserModel(
    id: id,
    name: json['name'],
  );
}
