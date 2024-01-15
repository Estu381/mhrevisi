import 'package:flutter/material.dart';
import 'package:mhofficials/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'slideshow.dart';
import 'ourgames.dart'; // Sesuaikan dengan path sebenarnya
import 'news.dart'; // Sesuaikan dengan path sebenarnya

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hapus inputan username
              SizedBox(height: 16.0),
              // Hapus inputan password
              SizedBox(height: 16.0),
              // Hapus tombol login

              // Tambahkan tombol edit slideshow
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke HalamanSlideshow saat tombol "Edit Slideshow" ditekan
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SlideshowPage(),
                    ),
                  );
                },
                child: Text('Edit Slideshow'),
              ),
              SizedBox(height: 16.0),

              // Tambahkan tombol edit our games
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke OurGamesPage saat tombol "Edit Our Games" ditekan
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OurGamesPage(),
                    ),
                  );
                },
                child: Text('Edit Our Games'),
              ),
              SizedBox(height: 16.0),

              // Tambahkan tombol edit news
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke NewsPage saat tombol "Edit News" ditekan
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsPage(),
                    ),
                  );
                },
                child: Text('Edit News'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  remove();
                  // Navigasi ke NewsPage saat tombol "Edit News" ditekan
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyApp(),
                    ),
                  );
                },
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> remove() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user_id');
    return true; // Penyimpanan berhasil
  } catch (e) {
    print("Error saving user_id to SharedPreferences: $e");
    return false; // Penyimpanan gagal
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}
