import 'package:flutter/material.dart';
import 'package:mhofficials/API/connect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart'; // Import file login_page.dart
import 'register_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
        backgroundColor: Color(0xFF4E2208),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Admin Page!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            _buildLoginForm(),
            SizedBox(height: 20.0),
            _buildRegisterButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Login',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(labelText: 'Username'),
        ),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(labelText: 'Password'),
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman LoginPage
                login();
              },
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman RegisterPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(adminIdList: []),
                  ),
                );
              },
              child: Text('Register'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    );
  }

  Future<void> login() async {
    try {
      var response = await http.post(Uri.parse(ApiConnect.login), body: {
        "username": _usernameController.text,
        "password": _passwordController.text,
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> user = jsonDecode(response.body);
        print(response.body);

        if (user['success'] == true) {
          final dynamic userId = user['data']['userId'];
          bool saveSuccess = await saveUserId(int.parse(userId));

          if (saveSuccess) {
            // Jika penyimpanan berhasil, lanjutkan dengan navigasi
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
            // Print hasil setelah berhasil menyimpan ke session manager
            print("User ID berhasil disimpan di SharedPreferences: $userId");
          } else {
            // Handle penyimpanan gagal jika diperlukan
            print("Failed to save user_id to SharedPreferences");
          }
        }
      } else {
        // Handle response status code other than 200
      }
    } catch (e) {
      print("Error during login: $e");
    }
  }

  Future<void> register() async {
    try {
      var response = await http.post(Uri.parse(ApiConnect.register), body: {
        "username": _usernameController.text,
        "password": _passwordController.text,
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> user = jsonDecode(response.body);
        print(response.body);

        if (user['success'] == true) {
          final dynamic userId = user['data']['userId'];
          bool saveSuccess = await saveUserId(int.parse(userId));

          if (saveSuccess) {
            // Jika penyimpanan berhasil, lanjutkan dengan navigasi
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
            // Print hasil setelah berhasil menyimpan ke session manager
            print("User ID berhasil disimpan di SharedPreferences: $userId");
          } else {
            // Handle penyimpanan gagal jika diperlukan
            print("Failed to save user_id to SharedPreferences");
          }
        }
      } else {
        // Handle response status code other than 200
      }
    } catch (e) {
      print("Error during login: $e");
    }
  }

  Future<bool> saveUserId(int userId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', userId);
      return true; // Penyimpanan berhasil
    } catch (e) {
      print("Error saving user_id to SharedPreferences: $e");
      return false; // Penyimpanan gagal
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: AdminPage(),
  ));
}
