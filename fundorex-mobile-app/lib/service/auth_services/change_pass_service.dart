import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/helper/extension/string_extension.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassService with ChangeNotifier {
  bool isloading = false;

  String? otpNumber;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  changePassword(
      currentPass, newPass, repeatNewPass, BuildContext context) async {
    if (newPass != repeatNewPass) {
      OthersHelper().showToast(
          'Make sure you repeated new password correctly', Colors.black);
    } else {
      if (baseApi.toLowerCase().contains("fundorex.xgenious")) {
        setLoadingTrue();
        await Future.delayed(const Duration(seconds: 2));
        setLoadingFalse();
        "This feature is turned off for demo app".showToast();
        return;
      }
      //check internet connection
      var connection = await checkConnection();
      if (connection) {
        //internet connection is on
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var token = prefs.getString('token');
        var header = {
          //if header type is application/json then the data should be in jsonEncode method
          "Accept": "application/json",
          // "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        };
        var data = {'current_password': currentPass, 'new_password': newPass};

        setLoadingTrue();

        var response = await http.post(
            Uri.parse('$baseApi/user/change-password'),
            headers: header,
            body: data);

        if (response.statusCode >= 200 && response.statusCode < 300) {
          OthersHelper().showToast(
              "Password changed successfully", ConstantColors().primaryColor);
          setLoadingFalse();

          prefs.setString("pass", newPass);

          Navigator.pop(context);
        } else {
          print(response.body);

          OthersHelper()
              .showToast(jsonDecode(response.body)['message'], Colors.black);

          setLoadingFalse();
        }
      }
    }
  }
}
