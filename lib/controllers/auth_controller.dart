import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final _baseUrl = 'https://peanut.ifxdb.com';

  var accessToken = ''.obs;
  RxMap<dynamic, dynamic> userInfo = <dynamic, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadToken();
  }

  Future<Map<String, dynamic>> fetchUserInfo() async {
    try {
      print('Token before making request: ${accessToken.value}');
      if (accessToken.value.isEmpty) {
        print('Token is empty. Returning empty user information.');
        return {};
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/api/ClientCabinetBasic/GetAccountInformation'),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${accessToken.value}',
        },
        body: jsonEncode({
          'login': accessToken.value, // Use the access token as the user login
          'token': accessToken.value,
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        userInfo.assignAll(data);
        print('User Info: $data');
        return data as Map<String, dynamic>;
      } else {
        print('Failed to fetch user information. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return {};
      }
    } catch (e) {
      print('Error fetching user information: $e');
      return {};
    }
  }


  Future<void> login(String login, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/ClientCabinetBasic/IsAccountCredentialsCorrect'),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'login': login,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['result'] == true) {
          accessToken.value = responseData['token'];
          print('Login successful! Token: ${accessToken.value}');
          saveToken(accessToken.value);
        } else {
          print('Failed to authenticate. Result: ${responseData['result']}');
          throw Exception('Failed to authenticate');
        }
      } else {
        print('Failed to authenticate. Status code: ${response.statusCode}');
        throw Exception('Failed to authenticate');
      }
    } catch (e) {
      print('Error during login: $e');
      throw Exception('Failed to authenticate');
    }
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('token');
    if (storedToken != null) {
      accessToken.value = storedToken;
      print('Token loaded from SharedPreferences: $storedToken');
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    print('Token saved to SharedPreferences: $token');
  }

  Future<void> logout() async {
    accessToken.value = '';
    clearToken();
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    print('Token cleared from SharedPreferences');
  }
}
