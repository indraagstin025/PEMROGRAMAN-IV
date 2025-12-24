import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'user.dart';

const String BaseUrl = 'https://reqres.in/api';

class DataService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: BaseUrl,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'x-api-key': 'reqres_b7c6017e6357442f9cd6652f1acc5645',
      },
    ),
  );

  Future<dynamic> getUsers() async {
    try {
      final res = await dio.get('/users');
      debugPrint('STATUS: ${res.statusCode}');
      debugPrint('DATA  : ${res.data}');
      return res.data;
    } catch (e) {
      debugPrint('ERROR: $e');
      return null;
    }
  }

  Future<UserCreate?> postUser(UserCreate user) async {
    try {
      final response = await dio.post('/users', data: user.toMap());

      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('DATA  : ${response.data}');

      if (response.statusCode == 201) {
        return UserCreate.fromJson(response.data);
      }
    } on DioException catch (e) {
      debugPrint('DIO ERROR STATUS :  ${e.response?.statusCode}');
      debugPrint('DIO ERROR DATA   :  ${e.response?.data}');
      return null;
    } catch (e) {
      debugPrint('ERROR $e');
      return null;
    }
    return null;
  }

  Future putUser(String idUser, String name, String job) async {
    try {
      final response = await dio.put(
        '/users/$idUser',
        data: {'name': name, 'job': job},
      );
      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future deleteUser(String idUser) async {
    try {
      final response = await dio.delete('/users/$idUser');

      debugPrint('STATUS : ${response.statusCode}');
      debugPrint('DATA   : ${response.data}');

      if (response.statusCode == 204) {
        return 'Delete user success';
      }

      return null;
    } on DioException catch (e) {
      debugPrint('DIO ERROR STATUS: ${e.response?.statusCode}');
      debugPrint('DIO ERROR DATA  : ${e.response?.data}');
      return null;
    } catch (e) {
      debugPrint('ERROR: $e');
      return null;
    }
  }

  Future<Iterable<User>?> getUserModel() async {
    try {
      final response = await dio.get('/users');

      if (response.statusCode == 200) {
        final users = (response.data['data'] as List)
            .map((user) => User.fromJson(user))
            .toList();

        return users;
      }
    } on DioException catch (e) {
      debugPrint('DIO ERROR STATUS: ${e.response?.statusCode}');
      debugPrint('DIO ERROR DATA  : ${e.response?.data}');
      return null;
    } catch (e) {
      debugPrint('ERROR: $e');
      return null;
    }
    return null;
  }
}
