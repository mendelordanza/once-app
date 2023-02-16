import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String id;
  String text;
  Timestamp? createdAt;

  TodoModel({
    required this.id,
    required this.text,
    this.createdAt,
  });

  factory TodoModel.fromJson(String id, Map<dynamic, dynamic> json) => TodoModel(
    id: id,
    text: json['text'],
    createdAt: json['createdAt'],
  );

  dynamic toJson() => {
    'text': text,
  };
}