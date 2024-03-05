import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

List<Device> deviceData = [];
final fmt1 = DateFormat("MMM d yyyy hh:mm:ss");
final fmt = DateFormat('dd-MM-yyyy_HH-mm-ss');
final fmt3 = DateFormat('yyyy-MM-dd HH:mm:ss');
// COLORS
const backgroundColor = Colors.white;

const buttonColor = Colors.green;
// const buttonColor = Colors.black;
const borderColor = Colors.purple;

Future<String> isUserFound(String email, String psw) async {
  var bytes = utf8.encode(psw); // data being hashed
  var digest = md5.convert(bytes);
  // print(digest);
  final response = await http.get(
    Uri.parse('https://fukaqwjsci.execute-api.us-east-1.amazonaws.com/login'),
    headers: {
      'password': "$digest",
      'email': email,
    },
  );
  if (response.statusCode == 200) {
    String res = jsonDecode(response.body).toString();
    // print(res);
    // getData(email);
    return res == 'ok' ? '200' : '400';
  } else {
    throw Exception('Failed to load api');
  }
}

Future<String> getData(String email) async {
  final response = await http.get(
    Uri.parse(
        'https://9on7spe9y0.execute-api.us-east-1.amazonaws.com/default/advancetech_device_activity'),
    // headers: {
    //   'email': email,
    // },
  );
  final response1 = await http.get(
    Uri.parse('https://fukaqwjsci.execute-api.us-east-1.amazonaws.com/data'),
    headers: {
      'email': email,
    },
  );
  // print(response.body);
  // print(response1.body);

  DateTime current = DateTime.now();
  String now = fmt.format(current);

  int nowInMS = fmt.parse(now).millisecondsSinceEpoch;
  print(now);
  deviceData.clear();
  for (var i in jsonDecode(response.body)) {
    // print(i);
    deviceData.add(Device.fromJson(i, nowInMS));
  }
  for (var i in jsonDecode(response1.body)) {
    // print(i);
    deviceData.add(Device.fromJson1(i, nowInMS));
  }
  deviceData.sort((a, b) => a.deviceId.compareTo(b.deviceId));
  deviceData.sort(compareDevices); // sort the list
  return deviceData.isEmpty ? '400' : '200';
  // } else {
  //   throw Exception('Failed to load api');
  // }
}

class Device {
  final String deviceId;
  final bool registerStatus;
  final String status;

  const Device({
    required this.deviceId,
    required this.registerStatus,
    required this.status,
  });

  factory Device.fromJson(Map<String, dynamic> dvc, nowInMS) {
    if (dvc['lastReceivedTime'] == 'empty') {
      return Device(
        deviceId: dvc['DeviceId'],
        registerStatus: true,
        status: 'inactive',
      );
    } else {
      String dt = dvc['lastReceivedTime'];
      int previousDt;
      try {
        previousDt = fmt.parse(dt).millisecondsSinceEpoch;
        // code that may cause an exception
      } catch (e) {
        // code that handles the exception
        previousDt = fmt3.parse(dt).millisecondsSinceEpoch;
      }

      int distance = nowInMS - previousDt;
      print(dvc['DeviceId']);
      print(distance);
      print(dvc['lastReceivedTime']);
      // print(now);
      print(nowInMS);
      print(previousDt);
      if (distance < 180000) {
        return Device(
            deviceId: dvc['DeviceId'], registerStatus: true, status: "active");
      } else {
        return Device(
            deviceId: dvc['DeviceId'],
            registerStatus: true,
            status: 'inactive');
      }
    }
  }
  factory Device.fromJson1(Map<String, dynamic> dvc, nowInMS) {
    if (dvc['status'] == 'empty') {
      return Device(
        deviceId: dvc['device_id'],
        registerStatus: dvc['register_status'],
        status: 'inactive',
      );
    } else {
      String dt = dvc['status'].split(' ').sublist(1, 5).join(' ');
      int previousDt = fmt1.parse(dt).millisecondsSinceEpoch;
      int distance = nowInMS - previousDt;

      if (distance < 180000) {
        return Device(
            deviceId: dvc['device_id'],
            registerStatus: dvc['register_status'],
            status: "active");
      } else {
        return Device(
            deviceId: dvc['device_id'],
            registerStatus: dvc['register_status'],
            status: 'inactive');
      }
    }
  }
}

int compareDevices(Device a, Device b) {
  if (a.status == 'active' && b.status == 'inactive') {
    return -1;
  } else if (a.status == 'inactive' && b.status == 'active') {
    return 1;
  } else {
    return 0;
  }
}
