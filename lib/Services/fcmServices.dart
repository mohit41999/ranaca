import 'dart:convert';

import 'package:crush/Constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Fcm_Services {
  Future sendfcm(String userid, String fcm_token) async {
    var response = await http.post(
        Uri.parse('http://crush.notionprojects.tech/api/fcm_token.php'),
        body: {
          'token': Token,
          'user_id': userid,
          'fcm_token': fcm_token,
        });
    var Response = jsonDecode(response.body);
    print(Response);
  }
}
