import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/model/reward_points_model.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RewardPointsService with ChangeNotifier {
  List rewardPointsList = [];

  bool hasData = true;

  fetchRewardPoints(BuildContext context) async {
    if (rewardPointsList.isNotEmpty) return;

    //==============>

    var connection = await checkConnection();
    if (!connection) {
      OthersHelper().showSnackBar(context, 'Check your internet connection',
          ConstantColors().warningColor);
      return;
    }

    hasData = true;
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
        Uri.parse('$baseApi/user/donation/reward-points'),
        headers: header);

    print(response.body);

    if ((response.statusCode >= 200 && response.statusCode < 300) &&
        jsonDecode(response.body)['reward_points'].isNotEmpty) {
      final data = RewardPointsModel.fromJson(jsonDecode(response.body));
      rewardPointsList = data.rewardPoints;

      notifyListeners();
    } else {
      //Something went wrong
      hasData = false;
      notifyListeners();
    }
  }
}
