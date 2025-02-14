import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UserService extends GetxService {
  final String baseUrl = 'http://192.168.100.5:5000/users';

  Future<List<Map<String, dynamic>>> getUsers({int page = 1, int perPage = 5}) async {
    final response = await http.get(
      Uri.parse('$baseUrl?page=$page&per_page=$perPage'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['users']);
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  Future<Map<String, dynamic>> getUserById(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('User not found');
    }
  }

  Future<Map<String, dynamic>> getUserByUsername(String username) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$username'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('User not found');
    }
  }


  Future<Map<String, dynamic>?> getUserByPhone(String phone) async {
    final response = await http.get(
      Uri.parse('$baseUrl/phone/$phone'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('User not found');
    }
  }

  Future<Map<String, dynamic>> updateUser(int userId, Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(int userId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }
}
