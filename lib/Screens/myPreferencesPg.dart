import 'dart:convert';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:crush/Constants/constants.dart';
import 'package:crush/Model/myAccountModel.dart';
import 'package:crush/Services/myAccountService.dart';
import 'package:crush/util/App_constants/appconstants.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class MyPreferencesPg extends StatefulWidget {
  final String? user_id;

  const MyPreferencesPg({Key? key, required this.user_id}) : super(key: key);

  @override
  _MyPreferencesPgState createState() => _MyPreferencesPgState();
}

class _MyPreferencesPgState extends State<MyPreferencesPg> {
  Future mypreferences() async {
    if (ischangesapplied) {
      var Response = await http
          .post(Uri.parse(BASE_URL + AppConstants.MY_PREFERENCES), body: {
        'token': Token,
        'user_id': widget.user_id,
        'city': cityValue.toString(),
        'interested': gender.toString(),
        'min_age': currentRangeValues.start.toString(),
        'max_age': currentRangeValues.end.toString()
      });
      var response = jsonDecode(Response.body);
      print(response);
      if (Response.statusCode == 200) {
        setState(() {
          print(response);
          Navigator.pop(context);
        });
      }
    } else {
      Navigator.pop(context);
    }
  }

  String gender = '';
  late bool womenSwith = false;
  late bool menSwith = false;
  late bool bothSwith = false;

  String countryValue = DefaultCountry.India.toString();
  String? stateValue = '';
  String? cityValue = '';
  bool ischangesapplied = false;
  RangeValues currentRangeValues = const RangeValues(18, 40);
  late MyAccount accountdetails;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myAccountService().get_myAccount(widget.user_id).then((value) {
      setState(() {
        accountdetails = value;
        gender = accountdetails.data[0].interested.toString();
        print(gender);
        womenSwith = (gender == 'women') ? true : false;
        menSwith = (gender == 'men') ? true : false;
        bothSwith = (gender == 'both') ? true : false;
        print(accountdetails.data[0].total_coins.toString());
      });
      return accountdetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 25, 8, 8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                child: Text(
                  'My Preferences',
                  style: TextStyle(
                    color: appThemeColor,
                    fontSize: 20,
                    fontFamily: 'SegoeUI',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SelectState(
                // style: TextStyle(color: Colors.red),
                onCountryChanged: (value) {
                  setState(() {
                    countryValue = value;
                  });
                },
                onStateChanged: (value) {
                  setState(() {
                    stateValue = value;
                  });
                },
                onCityChanged: (value) {
                  setState(() {
                    cityValue = value;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CSCPicker(
                  showCities: true,
                  defaultCountry: DefaultCountry.India,

                  flagState: CountryFlag.DISABLE,

                  dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      border: Border.all(color: appThemeColor, width: 1)),

                  disabledDropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey,
                      border: Border.all(color: Colors.white, width: 1)),

                  ///Default Country

                  ///selected item style [OPTIONAL PARAMETER]
                  selectedItemStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),

                  ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                  dropdownHeadingStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),

                  ///DropdownDialog Item style [OPTIONAL PARAMETER]
                  dropdownItemStyle: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 14,
                  ),

                  ///Dialog box radius [OPTIONAL PARAMETER]
                  dropdownDialogRadius: 10.0,

                  ///Search bar radius [OPTIONAL PARAMETER]
                  searchBarRadius: 10.0,

                  ///triggers once country selected in dropdown
                  onCountryChanged: (value) {
                    setState(() {
                      ///store value in country variable
                      countryValue = value;
                      print(countryValue);
                    });
                  },

                  ///triggers once state selected in dropdown
                  onStateChanged: (value) {
                    setState(() {
                      ///store value in state variable
                      stateValue = value;
                    });
                  },

                  ///triggers once city selected in dropdown
                  onCityChanged: (value) {
                    setState(() {
                      ///store value in city variable
                      cityValue = value;
                      ischangesapplied = true;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text('I want to find.....',
                    style: TextStyle(
                      color: appThemeColor.withOpacity(0.8),
                      fontSize: 16,
                      fontFamily: 'SegoeUI',
                      fontWeight: FontWeight.w700,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Women',
                        style: TextStyle(
                            color: appThemeColor.withOpacity(0.8),
                            fontFamily: 'SegoeUI',
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                    FlutterSwitch(
                        activeIcon: Icon(
                          Icons.circle,
                          color: appThemeColor,
                        ),
                        toggleSize: 12,
                        height: 20,
                        width: 30,
                        activeColor: appThemeColor,
                        value: womenSwith,
                        onToggle: (value) {
                          setState(() {
                            (value)
                                ? gender = 'women'
                                : gender = accountdetails.data[0].interested
                                    .toString();
                            womenSwith = value;
                            menSwith = false;
                            bothSwith = false;
                          });
                        })
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Men',
                        style: TextStyle(
                            color: appThemeColor.withOpacity(0.8),
                            fontFamily: 'SegoeUI',
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                    FlutterSwitch(
                        activeIcon: Icon(
                          Icons.circle,
                          color: appThemeColor,
                        ),
                        toggleSize: 12,
                        height: 20,
                        width: 30,
                        activeColor: appThemeColor,
                        value: menSwith,
                        onToggle: (value) {
                          setState(() {
                            (value)
                                ? gender = 'men'
                                : gender = accountdetails.data[0].interested
                                    .toString();
                            womenSwith = false;
                            bothSwith = false;
                            menSwith = value;
                          });
                        })
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Both',
                        style: TextStyle(
                            color: appThemeColor.withOpacity(0.8),
                            fontFamily: 'SegoeUI',
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                    FlutterSwitch(
                        activeIcon: Icon(
                          Icons.circle,
                          color: appThemeColor,
                        ),
                        toggleSize: 12,
                        height: 20,
                        width: 30,
                        activeColor: appThemeColor,
                        value: bothSwith,
                        onToggle: (value) {
                          setState(() {
                            (value)
                                ? gender = 'both'
                                : gender = accountdetails.data[0].interested
                                    .toString();
                            menSwith = false;
                            womenSwith = false;
                            bothSwith = value;
                          });
                        })
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  children: [
                    Text(
                        '${currentRangeValues.start.round().toString()} - ${currentRangeValues.end.round().toString()} ',
                        style: TextStyle(
                            color: appThemeColor.withOpacity(0.8),
                            fontFamily: 'SegoeUI',
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    Text('  years old'),
                  ],
                ),
              ),
              RangeSlider(
                activeColor: appThemeColor,
                values: currentRangeValues,
                min: 0,
                max: 100,
                //divisions: 5,
                labels: RangeLabels(
                  currentRangeValues.start.round().toString(),
                  currentRangeValues.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    currentRangeValues = values;
                  });
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: commonBtn(
                    s: 'ApplyChanges',
                    bgcolor: appThemeColor,
                    textColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        mypreferences();
                      });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
