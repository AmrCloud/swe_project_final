import 'dart:async';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';
import '../../../../core/services/local_storage.dart';
import '../../../../core/errors/failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalStorage localStorage;

  AuthRepositoryImpl({required this.localStorage});

  @override
  Future<User?> getCurrentUser() async {
    try {
      final email = localStorage.getString('email');
      final name = localStorage.getString('name');
      
      if (email != null) {
        // Convert UserModel to User entity
        return UserModel(
          id: 'user_${email.hashCode}',
          email: email,
          name: name,
        ).toEntity();
      }
      return null;
    } catch (e) {
      throw CacheFailure('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      // Simulate network call
      await Future.delayed(const Duration(seconds: 1));
      
      await localStorage.saveString('email', email);
      
      // Convert UserModel to User entity
      return UserModel(
        id: 'user_${email.hashCode}',
        email: email,
      ).toEntity();
    } catch (e) {
      throw CacheFailure('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<User> register(String email, String password, String name) async {
    try {
      // Simulate network call
      await Future.delayed(const Duration(seconds: 1));
      
      await localStorage.saveString('email', email);
      await localStorage.saveString('name', name);
      
      // Convert UserModel to User entity
      return UserModel(
        id: 'user_${email.hashCode}',
        email: email,
        name: name,
      ).toEntity();
    } catch (e) {
      throw CacheFailure('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await localStorage.remove('email');
      await localStorage.remove('name');
    } catch (e) {
      throw CacheFailure('Logout failed: ${e.toString()}');
    }
  }
}