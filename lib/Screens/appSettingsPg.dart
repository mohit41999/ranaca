import 'dart:convert';

import 'package:crush/Constants/constants.dart';
import 'package:crush/Screens/signinScreen.dart';
import 'package:crush/Screens/splashScreen.dart';
import 'package:crush/Services/sendnotification.dart';
import 'package:crush/util/App_constants/appconstants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AppSettingsPg extends StatefulWidget {
  final String? user_id;
  const AppSettingsPg({Key? key, required this.user_id}) : super(key: key);

  @override
  _AppSettingsPgState createState() => _AppSettingsPgState();
}

class _AppSettingsPgState extends State<AppSettingsPg> {
  bool online_offline_Swith = false;
  bool voice_call_Swith = false;
  bool video_call_Swith = false;
  TextStyle reportText =
      TextStyle(color: Color(0xff0B0D0F).withOpacity(0.8), fontSize: 16);

  Future getinstance() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print(user!.displayName);
        print('User is currently signed out!');
      } else {
        print(user.displayName);
        print(user.email);
        print(user.phoneNumber);

        print('User is signed in!');
      }
    });
  }

  Future deleteUser() async {
    var Response = await http.post(
        Uri.parse(BASE_URL + AppConstants.DELETE_ACCOUNT),
        body: {'token': Token, 'user_id': widget.user_id});
    var response = jsonDecode(Response.body);
    if (response['status']) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen()),
          (route) => route.isFirst);
      Navigator.pop(context);
    }
  }

  logout() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool facebook = prefs.getBool('isFacebook')!;
    (facebook) ? await FacebookLogin().logOut() : await _googleSignIn.signOut();
    FirebaseAuth.instance.signOut();
    prefs.clear();

    prefs.remove('phonenumber');
    prefs.remove('user_id');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'App Settings',
              style: TextStyle(
                  color: appThemeColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Text('Notification', style: TextStyle(fontSize: 16)),
            Text(
              'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea.',
              style: TextStyle(
                  color: Color(0xff0B0D0F).withOpacity(0.6), fontSize: 14),
            ),
            GestureDetector(
              onTap: () {
                logout();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SplashScreen()),
                    (route) => route.isFirst);
                Navigator.pop(context);
              },
              child: Text(
                'Logout',
                style: TextStyle(
                    color: appThemeColor.withOpacity(0.8), fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 66),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    logout();
                    deleteUser();
                  });
                },
                child: Text(
                  'Delete My Account',
                  style: TextStyle(
                      color: Colors.red.withOpacity(0.8), fontSize: 16),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                launch('http://crush.net.in/terms-of-use/');
              },
              child: Text(
                'Terms and Conditions of Use',
                style: TextStyle(
                    color: Color(0xff0B0D0F).withOpacity(0.6), fontSize: 16),
              ),
            ),
            InkWell(
              onTap: () {
                launch('http://crush.net.in/terms-of-use/');
              },
              child: Text('Privacy Policy',
                  style: TextStyle(
                      color: Color(0xff0B0D0F).withOpacity(0.6), fontSize: 16)),
            ),
            Text('Help Centre',
                style: TextStyle(
                    color: Color(0xff0B0D0F).withOpacity(0.6), fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
