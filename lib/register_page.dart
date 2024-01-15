import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mhofficials/API/connect.dart';
import 'package:mhofficials/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  final List<String> adminIdList;

  const RegisterPage({Key? key, required this.adminIdList}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> registers() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/flutter_api/register.php'),
      body: {
        'username': usernameController.text,
        'password': passwordController.text,
      },
    );

    // Tambahkan output log untuk melihat respons dari server
    print('Response: ${response.body}');
    final result = json.decode(response.body);

    if (response.statusCode == 200) {
      if (result['status'] == 'success') {
        // Registrasi berhasil, tambahkan admin_id ke daftar
        // widget.adminIdList.add(adminIdController.text);

        // Tampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful!'),
          ),
        );

        // Kembali ke halaman sebelumnya (AdminPage)
        Navigator.pop(context);
      } else {
        // Tampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
          ),
        );
      }
    } else {
      // Tampilkan pesan error jika gagal terhubung ke server
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Color(0xFF4E2208),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Validasi form sebelum melakukan registrasi
                if (usernameController.text.isEmpty ||
                    passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill in all fields.'),
                    ),
                  );
                } else {
                  // Lakukan registrasi jika formulir sudah terisi
                  register();
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> register() async {
    try {
      var response = await http.post(Uri.parse(ApiConnect.register), body: {
        "username": usernameController.text,
        "password": passwordController.text,
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Registration successful!'),
              ),
            );
            // Print hasil setelah berhasil menyimpan ke session manager
            print("User ID berhasil disimpan di SharedPreferences: $userId");
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(user['message']),
              ),
            );
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
