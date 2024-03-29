import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mhofficials/API/connect.dart';
import 'package:mhofficials/slideshow.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:developer';

class EditPage extends StatefulWidget {
  const EditPage(
      {Key? key,
      required this.id,
      required this.headline,
      required this.content,
      required this.image,
      required this.status})
      : super(key: key);

  final String id;
  final String headline;
  final String content;
  final String image;
  final String status;
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController headlineController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  File? image;
  String selectedStatus = "";

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Edit Page",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              edit();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              value: selectedStatus,
              onChanged: (String? newValue) {
                setState(() {
                  selectedStatus = newValue!;
                });
              },
              items: <String>['Slideshow', 'Our Games', 'News']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.blue[200]),
              child: TextField(
                controller: headlineController..text = widget.headline,
                decoration: InputDecoration(
                    hintText: 'Headline', border: InputBorder.none),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.blue[200]),
                child: TextField(
                  controller: contentController..text = widget.content,
                  maxLines: 10,
                  decoration: InputDecoration(
                      hintText: 'Content', border: InputBorder.none),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 190,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(
                      image ?? File(""),
                    ),
                  )),
            ),
            ElevatedButton(
              onPressed: () {
                _potoBottomSheet();
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue)),
              child: Text(
                'Tambah Foto',
                style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> edit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    // String date = DateTime.now().toString();
    print("$userId Ini Session");
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConnect.edit),
      );

      request.fields.addAll({
        "user_id": userId.toString(),
        "id": widget.id.toString(),
        "headline": headlineController.text,
        "content": contentController.text,
        "status": selectedStatus.toString(),
      });

      if (image != null) {
        // Menambahkan gambar ke dalam permintaan multipart
        request.files.add(http.MultipartFile(
          'image',
          http.ByteStream(image!.openRead().cast()),
          await image!.length(),
          filename: headlineController.text + '_board_image.jpg',
        ));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        print(responseBody);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SlideshowPage()),
        );
      } else {
        // Handle response status code other than 200
        print("HTTP request failed with status ${response.statusCode}");
      }
    } catch (e) {
      print("Error during registration: $e");
    }
  }

  Future<void> getImageGalerry() async {
    var galleryPermission = Permission.storage;

    if (galleryPermission.status == PermissionStatus.denied) {
      galleryPermission.request();
      if (galleryPermission.status == PermissionStatus.permanentlyDenied) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(""))
          ]),
        );
      }
    }

    final ImagePicker picker = ImagePicker();
    final imagePicked = await picker.pickImage(source: ImageSource.gallery);
    image = File(imagePicked?.path ?? "");
    setState(() {});
  }

  Future getImageCamera() async {
    final ImagePicker picker = ImagePicker();
    final imagePicked = await picker.pickImage(source: ImageSource.camera);
    image = File(imagePicked!.path);
    setState(() {});
  }

  Future _potoBottomSheet() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 5,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    onTap: () async {
                      await getImageGalerry();
                    },
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.blue.withOpacity(0.1),
                      ),
                      child: const Icon(
                        Icons.image,
                        color: Colors.blue,
                      ),
                    ),
                    title: Text("Upload dari Galeri",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF454444),
                        )),
                    trailing: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey.shade200,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue,
                        size: 15,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      await getImageCamera();
                    },
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.blue.withOpacity(0.1),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.blue,
                      ),
                    ),
                    title: Text("Upload dari Kamera",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF454444),
                        )),
                    trailing: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey.shade200,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue,
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
