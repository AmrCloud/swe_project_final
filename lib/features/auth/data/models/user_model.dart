import '../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String email;
  final String? name;

  UserModel({
    required this.id,
    required this.email,
    this.name,
  });

  // Convert to domain entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }
}