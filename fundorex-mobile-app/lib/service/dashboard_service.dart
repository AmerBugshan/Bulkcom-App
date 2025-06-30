// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardService with ChangeNotifier {
  var eventBooked;
  var totalDonation;
  var totalCampaign;
  var totalReward;
  List dashboardDataList = [];

  fetchDashboardData(BuildContext context) async {
    //==============>

    var connection = await checkConnection();
    if (!connection) {
      OthersHelper().showSnackBar(context, 'Check your internet connection',
          ConstantColors().warningColor);
      return;
    }

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
      var response =
          await http.get(Uri.parse('$baseApi/user/dashboard'), headers: header);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        dashboardDataList = [];
        notifyListeners();

        var jsonData = jsonDecode(response.body);

        dashboardDataList.add(jsonData['events_booked']);
        dashboardDataList.add(jsonData['total_donation']);
        dashboardDataList.add(jsonData['total_campaigns']);
        dashboardDataList.add(jsonData['total_reward_points']);

        notifyListeners();
      } else {
        //Something went wrong
      }
    } catch (e) {
      OthersHelper()
          .showSnackBar(context, e.toString(), ConstantColors().warningColor);
    }
  }
}
