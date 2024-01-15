import 'package:flutter/material.dart';
import 'package:mhofficials/API/connect.dart';
import 'package:mhofficials/Model/Game.dart';
import 'package:mhofficials/newpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

class OurGamesPage extends StatefulWidget {
  @override
  _OurGamesPageState createState() => _OurGamesPageState();
}

class _OurGamesPageState extends State<OurGamesPage> {
  List<GameData> _notesList = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Our Games'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Updated to 2 for two images per row
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: _notesList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirmation"),
                        content:
                            Text("Are you sure you want to delete this data?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.grey),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Call your delete function here
                              deleteData(_notesList[index].id);
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text(
                              "Delete",
                              style: TextStyle(color: Colors.blue),
                            ),
                            style: ButtonStyle(
                              side:
                                  MaterialStateProperty.resolveWith<BorderSide>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return BorderSide(
                                        color: Colors
                                            .grey); // Color when the button is disabled
                                  }
                                  return BorderSide(
                                      color: Colors
                                          .blue); // Color when the button is enabled
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    // Add navigation or other actions if needed
                    );
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2 -
                    16.0, // Adjusted for two images
                height: MediaQuery.of(context).size.width / 2 -
                    16.0, // Adjusted for two images
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      ApiConnect.connectApi +
                          "/assets/" +
                          _notesList[index].image!,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 8.0),
                    // Add text or other widgets if needed
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        shape: CircleBorder(),
      ),
    );
  }

  Future<void> getData() async {
    try {
      final response = await http.post(Uri.parse(ApiConnect.get), body: {});

      if (response.statusCode == 200) {
        Iterable it = jsonDecode(response.body);

        // Filter the data based on the status "slide"
        List<GameData> notesList = it
            .where((e) => e['status'] == 'Our Games')
            .map((e) => GameData.fromJson(e))
            .toList();

        // Update the state with the fetched data
        setState(() {
          _notesList = notesList;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteData(String? noteId) async {
    try {
      var response = await http.post(
        Uri.parse(ApiConnect.delete),
        body: {
          "id": noteId,
        },
      );

      if (response.statusCode == 200) {
        // Remove the deleted note from the local list
        setState(() {
          _notesList.removeWhere((note) => note.id == noteId);
        });
        print("Success");
      } else {
        throw Exception("Failed to delete data from the server");
      }
    } catch (e) {
      print("Error: $e");
      throw e;
    }
  }
}
