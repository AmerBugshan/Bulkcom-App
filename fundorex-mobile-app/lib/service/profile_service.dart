import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/model/profile_model.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService with ChangeNotifier {
  bool isloading = false;

  var profileDetails;

  List ordersList = [];

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  setEverythingToDefault() {
    profileDetails = null;

    ordersList = [];
    notifyListeners();
  }

  getProfileDetails({bool isFromProfileupdatePage = false}) async {
    if (isFromProfileupdatePage == true) {
      //if from update profile page then load it anyway
      print('is from profile update page true');
      setEverythingToDefault();
      fetchData();
    } else {
      //not from profile page. check if data already loaded
      if (profileDetails == null) {
        fetchData();
      } else {
        print('profile data already loaded');
      }
    }
  }

  fetchData() async {
    var connection = await checkConnection();
    if (connection) {
      //internet connection is on
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      setLoadingTrue();

      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        // "Content-Type": "application/json"
        "Authorization": "Bearer $token",
      };

      var response =
          await http.get(Uri.parse('$baseApi/user/profile'), headers: header);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print(response.body);
        var data = ProfileModel.fromJson(jsonDecode(response.body));
        profileDetails = data.userDetails;

        notifyListeners();
      } else {
        print('profile fetch error ${response.body}');
        profileDetails == 'error';
        setLoadingFalse();
        notifyListeners();
      }
    }
  }
}
