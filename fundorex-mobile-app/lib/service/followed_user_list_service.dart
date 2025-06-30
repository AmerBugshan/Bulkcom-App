import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/model/followed_user_list_model.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FollowedUserListService with ChangeNotifier {
  List followedUserList = [];

  bool hasError = false;
  bool isloading = false;

  fetchFollowedUser() async {
    var connection = await checkConnection();

    if (!connection) return;

    if (followedUserList.isNotEmpty) return;

    hasError = false;
    isloading = true;

    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      // "Content-Type": "application/json"
      "Authorization": "Bearer $token",
    };

    //if connection is ok
    var response = await http.get(
        Uri.parse('$baseApi/user/donation/followed-user'),
        headers: header);
    isloading = false;

    if ((response.statusCode >= 200 && response.statusCode < 300) &&
        jsonDecode(response.body)['data'].isNotEmpty) {
      var data = FollowedUserListModel.fromJson(jsonDecode(response.body));
      followedUserList = data.data;
      notifyListeners();
    } else {
      print('error fetching followed user list ${response.body}');

      //Something went wrong
      hasError = true;

      notifyListeners();
    }
  }
}
