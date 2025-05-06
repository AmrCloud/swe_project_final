import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterRequested extends RegisterEvent {
  final String name;
  final String email;
  final String password;
  final String gender;
  final int age;

  const RegisterRequested(
      {required this.name,
      required this.email,
      required this.password,
      required this.gender,
      required this.age});

  @override
  List<Object> get props => [name, email, password, gender, age];
}