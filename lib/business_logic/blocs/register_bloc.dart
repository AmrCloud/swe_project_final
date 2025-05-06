import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:sugarsense/business_logic/blocs/register_event.dart';
import 'package:sugarsense/business_logic/blocs/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      const String apiUrl = 'http://192.168.1.4:5000/api/auth/register';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': event.name,
          'email': event.email,
          'password': event.password,
          'gender': event.gender,
          'age': event.age,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String message = responseData['message'];
        emit(RegisterSuccess(message: message));
      } else {
        emit(RegisterFailure(
            error:
                'Register failed with status code: ${response.statusCode} - ${response.body}'));
      }
    } catch (e) {
      emit(RegisterFailure(error: 'Failed to connect to the server: $e'));
    }
  }
}