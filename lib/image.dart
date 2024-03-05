import 'package:detest/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'colors.dart';
import 'home_screen.dart';
// ignore: depend_on_referenced_packages
//import 'package:fluttertoast/fluttertoast.dart';

class Pictures extends StatefulWidget {
  final String deviceId;
  const Pictures({super.key, required this.deviceId});
  @override
  _PicturesState createState() => _PicturesState();
}

class _PicturesState extends State<Pictures> {
  // final String apiUrl =
  //     'https://tulp6xq61c.execute-api.us-east-1.amazonaws.com/dep/images?device=02&date=23-02-2024';

  List<String> imageUrls = [];
  int batchSize = 10;
  int currentPage = 0;
  DateTime selectedDate = DateTime.now();

  bool isLoading = true;

  var _startDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: Row(
          children: [
            const Icon(
              CupertinoIcons.camera,
              size: 35,
            ),
            const SizedBox(
              width: 10,
            ),
            const SizedBox(
              child: Text("Image data",
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.black)),
            )
          ],
        ),
        actions: MediaQuery.of(context).size.width > 600
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          email: 'milanpreetkaur502@gmail.com',
                        ),
                      ),
                    );
                  },
                  icon: Icon(CupertinoIcons.macwindow, size: 25),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(CupertinoIcons.globe, size: 25),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    CupertinoIcons.location_solid,
                    size: 25,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    CupertinoIcons.gear,
                    size: 25,
                  ),
                ),
              ]
            : [
                IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(Icons.menu),
                )
              ],
      ),
      drawer: MediaQuery.of(context).size.width > 600
          ? null
          : Drawer(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(CupertinoIcons.macwindow, size: 25),
                    title: Text('Dashboard'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(
                            email: 'milanpreetkaur502@gmail.com',
                          ),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(CupertinoIcons.globe, size: 25),
                    title: Text('Countries'),
                    onTap: () {
                      // Implement action
                    },
                  ),
                  ListTile(
                    leading: Icon(CupertinoIcons.location_solid, size: 25),
                    title: Text('Location'),
                    onTap: () {
                      // Implement action
                    },
                  ),
                  ListTile(
                    leading: Icon(CupertinoIcons.gear, size: 25),
                    title: Text('Settings'),
                    onTap: () {
                      // Implement action
                    },
                  ),
                ],
              ),
            ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'images/image3.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Your content
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  onTap: () => _selectDate(context),
                  decoration: InputDecoration(
                    labelText: 'Select Date',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  controller: TextEditingController(
                      text: selectedDate != null
                          ? DateFormat('dd-MM-yyyy').format(selectedDate)
                          : ''),
                ),
                Expanded(
                  child: isLoading
                      ? FutureBuilder<List<String>>(
                          future: fetchImages(widget.deviceId, selectedDate),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Text('Loading...');
                            } else {
                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return Image.network(snapshot.data![index]);
                                },
                              );
                            }
                          },
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: imageUrls.length,
                          itemBuilder: (context, index) {
                            // return Image.network(imageUrls[index]);
                            // return Padding(
                            //     padding: const EdgeInsets.all(16.0),
                            //     child: Container(
                            //       height: 500,
                            //       width: 800,
                            //       child: Image.network(imageUrls[index]),
                            //     )
                            // );
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FullScreenImage(imageUrls[index])));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(90.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      // gradient: LinearGradient(
                                      //   begin: Alignment.topCenter,
                                      //   end: Alignment.bottomCenter,
                                      //   colors: [
                                      //     Color.fromARGB(255, 135, 154, 169),
                                      //     Color.fromARGB(255, 216, 216, 216)
                                      //   ], // Example gradient colors
                                      // ),
                                      border: Border.all(
                                    color: Colors.transparent,
                                  )),
                                  child: Image.network(imageUrls[index]),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                      onPressed: currentPage > 0 ? moveToPreviousPage : null,
                      child: Text(
                        'Previous',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: blueshades),
                      onPressed: moveToNextPage,
                      child: Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: blueshades,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                elevation: 10,
                backgroundColor: Colors.white, // button text color
              ),
            ),
          ),
          // child: child!,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child ?? Container(),
          ),
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      final newImages = await fetchImages(widget.deviceId, picked);
      setState(() {
        selectedDate = picked;
        imageUrls = newImages;
      });
    }
  }

  Future<List<String>> fetchImages(String device, DateTime date) async {
    final formattedDate = DateFormat('dd-MM-yyyy').format(date);
    final response = await http.get(Uri.parse(
        'https://h6vbv48c00.execute-api.us-east-1.amazonaws.com/dep/images?device=$device&date=${formattedDate.toString()}'));
    List<String> currentBatch = [];

    if (response.statusCode == 200) {
      final bodyJson = json.decode(response.body);
      final images = json.decode(bodyJson['body'])['images'];

      // Extract image URLs
      for (int i = currentPage * batchSize;
          i < (currentPage + 1) * batchSize && i < images.length;
          i++) {
        currentBatch.add(images[i]);
      }

      // Update the list of image URLs
      imageUrls = currentBatch;
    } else {
      throw Exception('Failed to load images');
    }

    // Show loading text for a short duration
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isLoading = false;
      });
    });

    return imageUrls;
  }

  void moveToNextPage() {
    setState(() {
      currentPage++;
      isLoading = true;
    });
  }

  void moveToPreviousPage() {
    setState(() {
      currentPage--;
      isLoading = true;
    });
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
