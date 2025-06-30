// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FollowUserService with ChangeNotifier {
  bool isFollowingUser = false;

  bool isLoading = false;

  followUser(
      {required BuildContext context,
      required campaignOwnerId,
      required userType}) async {
    var connection = await checkConnection();
    if (!connection) {
      OthersHelper().showSnackBar(context, 'Check your internet connection',
          ConstantColors().warningColor);
      return;
    }

    isLoading = true;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var userId = prefs.getInt('userId');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var data = jsonEncode({
      'user_id': userId,
      'campaign_owner_id': campaignOwnerId,
      'user_type': userType,
      'text': 'follow'
    });

    var response = await http.post(
        Uri.parse("$baseApi/user/donation/user-follow-store"),
        headers: header,
        body: data);

    isLoading = false;
    notifyListeners();

    print(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData = jsonDecode(response.body)['follow_status'];
      if (jsonData == 'follow' || jsonData == 'Follow') {
        isFollowingUser = true;
        notifyListeners();
      } else {
        isFollowingUser = false;
        notifyListeners();
      }

      // Future.delayed(const Duration(microseconds: 1000), () {
      // isFollowingUser = false;
      // });
    } else {
      print('error following user ${response.body}');
    }
  }

  /// check if followed =======
  /// //======================>

  checkIfFollowed(BuildContext context, campaignOwnerId) async {
    isFollowingUser = false;
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
    try {
      var response = await http.get(
          Uri.parse('$baseApi/user/check-followed/$campaignOwnerId'),
          headers: header);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        isFollowingUser = jsonDecode(response.body);

        notifyListeners();

        // Future.delayed(const Duration(milliseconds: 700), () {
        //   isFollowingUser = false;
        // });
      } else {
        //Something went wrong
      }
    } catch (e) {
      print('error checking if user followed ${e.toString()}');
    }
  }
}
