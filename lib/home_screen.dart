import 'dart:convert';
import 'package:detest/colors.dart';
import 'package:detest/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:detest/text_input_field.dart';
import 'package:flutter/material.dart';
import 'config_screen.dart';
import 'constant.dart';
import 'package:detest/weatherData.dart';
import 'package:detest/insectCount.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';

import 'image.dart';
//import 'package:detest/Battery.dart';

class HomeScreen extends StatefulWidget {
  final String email;

  const HomeScreen({super.key, required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List<Device> filterData =
    deviceData.where((device) => device.deviceId == "16").toList();

class _HomeScreenState extends State<HomeScreen> {
  late Future<String> response;
  late TextEditingController _serialId;
  late TextEditingController _securityKey;
  late TextEditingController dateController;
  late TextEditingController timeinput;
  late String result;
  late int sleepDuration = 0;
  bool _hovering = false;
  bool condition = false;
  @override
  void initState() {
    response = getData(widget.email);
    _serialId = TextEditingController();
    _securityKey = TextEditingController();
    dateController = TextEditingController();
    timeinput = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _serialId.dispose();
    _securityKey.dispose();
    super.dispose();
  }

  // Future<void> _dialogBuilder(BuildContext context) {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: Colors.white,
  //         title: const Center(
  //             child: Text(
  //           'Register a new Device ',
  //           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
  //         )),
  //         content: SizedBox(
  //           height: 140,
  //           width: 400,
  //           child: Column(
  //             children: [
  //               const SizedBox(height: 10),
  //               Container(
  //                 width: MediaQuery.of(context).size.width,
  //                 margin: const EdgeInsets.symmetric(horizontal: 20),
  //                 child: TextInputField(
  //                   initalvalue: 'D0999',
  //                   controller: _serialId,
  //                   labelText: 'Device ID',
  //                   icon: Icons.devices,
  //                 ),
  //               ),
  //               const SizedBox(height: 25),
  //               Container(
  //                 width: MediaQuery.of(context).size.width,
  //                 margin: const EdgeInsets.symmetric(horizontal: 20),
  //                 child: TextInputField(
  //                   initalvalue: '1234',
  //                   controller: _securityKey,
  //                   labelText: 'Serial ID',
  //                   icon: Icons.devices,
  //                   // isObscure: true,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           MaterialButton(
  //             textColor: Colors.white,
  //             color: Color.fromARGB(255, 190, 30, 18),
  //             child: const Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           MaterialButton(
  //             textColor: Colors.white,
  //             color: Colors.green,
  //             child: const Text('Register'),
  //             onPressed: () {
  //               RegistrationUser();
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Future RegistrationUser() async {
  //   var APIURL = Uri.parse(
  //       "https://uo1t934012.execute-api.us-east-1.amazonaws.com//addNewDevice");
  //   Map mapeddate = {
  //     'device_id': _serialId.text,
  //     'serial_id': _securityKey.text,
  //     'email': widget.email
  //   };
  //   String requestBody = jsonEncode(mapeddate);
  //   // print("JSON DATA: ${requestBody}");
  //   http.Response response = await http.post(APIURL, body: requestBody);
  //   var data = jsonDecode(response.body);
  //   if (response.statusCode == 200) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(data.toString()),
  //         duration: Duration(seconds: 3),
  //         backgroundColor: Colors.black,
  //       ),
  //     );
  //   } else {
  //     throw Exception('Failed to load api');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(
              CupertinoIcons.macwindow,
              size: 35,
            ),
            const SizedBox(
              width: 10,
            ),
            const SizedBox(
              child: Text(
                "Dashboard",
                style: TextStyle(
                  color: Colors.black87,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          ],
        ),
        actions: MediaQuery.of(context).size.width > 600
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );
                  },
                  icon: Icon(CupertinoIcons.home, size: 25),
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
      body: FutureBuilder<String>(
        future: response,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == '200') {
              // print(data);
              return Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/homescreen2.png"),
                        fit: BoxFit.contain)),
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      child: Container(
                        height: 50,
                        decoration: const BoxDecoration(
                          color: blueshades,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          child: Table(
                            columnWidths: const {
                              0: FlexColumnWidth(),
                              1: FlexColumnWidth(),
                              2: FlexColumnWidth(),
                              3: FlexColumnWidth(),
                            },
                            children: const <TableRow>[
                              TableRow(children: <Widget>[
                                Center(
                                  child: Text(
                                    'S.NO',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: backgroundColor),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'DEVICE ID',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: backgroundColor),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Image Data',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: backgroundColor),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Image',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: backgroundColor),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ),
                    ),
                    for (int i = 0; i < filterData.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        child: Container(
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 0),
                            child: Table(
                              columnWidths: const {
                                0: FlexColumnWidth(),
                                1: FlexColumnWidth(),
                                2: FlexColumnWidth(),
                                3: FlexColumnWidth(),
                              },
                              children: [
                                TableRow(children: [
                                  SizedBox(
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                        '${i + 1}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                        filterData[i].deviceId,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                        filterData[i].status,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () {
                                          // print('Status');
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => Pictures(
                                                // values: [],
                                                deviceId:
                                                    filterData[i].deviceId,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          CupertinoIcons.camera,
                                          color: Colors.black,
                                        ),
                                        // label: const Text('TempDB Data'),
                                        style: ElevatedButton.styleFrom(
                                            // elevation: 10,
                                            backgroundColor: Colors.white10),
                                      ),
                                    ),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }
            return Container();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.grey,
          ));
        }),
      ),
    );
  }
}
