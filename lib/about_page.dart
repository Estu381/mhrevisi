import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monster Hunter Description'),
        backgroundColor: Color(0xFF4e2208), // Ganti dengan warna yang sesuai
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'), // Ganti dengan path gambar yang sesuai
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.black.withOpacity(0.7),
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'About Monster Hunter',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 16.0), // Adjust the spacing between title and paragraphs
                    Text(
                      'The Monster Hunter series features action RPG games '
                          'that pit players against giant monsters in a beautiful '
                          'natural environment.',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 16.0), // Adjust the spacing between paragraphs
                    Text(
                      'From the birth of the franchise through the first title '
                          'debut in 2004, the games popularized the genre of co-op '
                          'action games focused on hunting giant monsters, '
                          'and has now grown into a megahit with fans from all '
                          'over the world.',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
