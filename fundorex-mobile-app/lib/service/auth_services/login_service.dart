// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/helper/extension/string_extension.dart';
import 'package:fundorex/service/profile_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/responsive.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common_service.dart';
import 'signup_service.dart';

class LoginService with ChangeNotifier {
  bool isloading = false;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  Future<bool> login(email, pass, BuildContext context, bool keepLoggedIn,
      {isFromLoginPage = true}) async {
    var connection = await checkConnection();
    if (connection) {
      setLoadingTrue();
      var data = jsonEncode({
        'email': email,
        'password': pass,
      });
      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        "Content-Type": "application/json"
      };

      var response = await http.post(Uri.parse('$baseApi/login'),
          body: data, headers: header);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        //start stripe
        //============>

        String token = jsonDecode(response.body)['token'];
        int userId = jsonDecode(response.body)['users']['id'];
        setToken(token);
        // String state = jsonDecode(response.body)['users']['state'].toString();
        String country_id =
            jsonDecode(response.body)['users']['country_id'].toString();
        await Provider.of<ProfileService>(context, listen: false).fetchData();

        setLoadingFalse();
        // Navigator.pushReplacement<void, void>(
        //   context,
        //   MaterialPageRoute<void>(
        //     builder: (BuildContext context) => const LandingPage(),
        //   ),
        // );

        if (keepLoggedIn) {
          saveDetails(email, pass, token, userId, country_id);
        } else {
          setKeepLoggedInFalseSaveToken(token);
        }

        print(response.body);

        return true;
      } else {
        print(response.body);
        //Login unsuccessful ==========>
        if (isFromLoginPage) {
          try {
            final js = jsonDecode(response.body);
            if (js["message"] != null) {
              js["message"]?.toString().showToast();
            } else if (js["validation_errors"] != null) {
              showError(js["validation_errors"])?.toString().showToast();
            } else {
              throw "";
            }
          } catch (e) {
            response.reasonPhrase.toString().showToast();
          }
        }
        setLoadingFalse();
        return false;
      }
    } else {
      //internet off
      return false;
    }
  }

  saveDetails(String email, pass, String token, int userId, country_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
    prefs.setBool('keepLoggedIn', true);
    // prefs.setString("pass", pass);
    prefs.setString("token", token);
    prefs.setInt('userId', userId);
    prefs.setString("countryId", country_id.toString());
    print('token is $token');
    print('user id is $userId');
  }

  setKeepLoggedInFalseSaveToken(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('keepLoggedIn', false);
    prefs.setString("token", token);
  }
}
