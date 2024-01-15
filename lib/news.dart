import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mhofficials/API/connect.dart';
import 'package:mhofficials/Model/Game.dart';
import 'package:mhofficials/editPage.dart';
import 'package:mhofficials/newpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPage createState() => _NewsPage();
}

class _NewsPage extends State<NewsPage> {
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
        title: Text('News Page'),
      ),
      body: ListView.builder(
        itemCount: _notesList.length,
        itemBuilder: (context, index) {
          return Slidable(
            key: ValueKey(index),
            endActionPane: ActionPane(
                extentRatio: 0.18,
                motion: ScrollMotion(),
                children: [
                  Column(children: [
                    InkWell(
                      onTap: () {
                        // Call deleteData method with the note's ID
                        deleteData(_notesList[index].id);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SvgPicture.asset(
                            'assets/trash.svg',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPage(
                              id: _notesList[index].id ?? '',
                              headline: _notesList[index].headline ?? '',
                              content: _notesList[index].content ?? '',
                              image: _notesList[index].image ?? '',
                              status: _notesList[index].status ?? '',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ])
                ]),
            child: Container(
              margin: EdgeInsets.only(bottom: 16.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      ApiConnect.connectApi +
                          "/assets/" +
                          _notesList[index].image!,
                      width: 200.0,
                      height: 150.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    _notesList[index].headline!,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    _notesList[index].content!,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          );
        },
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
            .where((e) => e['status'] == 'News')
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
