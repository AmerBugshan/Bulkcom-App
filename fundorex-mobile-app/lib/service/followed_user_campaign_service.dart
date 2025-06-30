import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:fundorex/model/followed_user_campaign_model.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FollowedUserCampaignService with ChangeNotifier {
  //All  feature campaign service
  var followedUserCampaignList = [];

  bool hasData = true;

  late int totalPages;

  int currentPage = 1;

  setCurrentPage(newValue) {
    currentPage = newValue;
    notifyListeners();
  }

  setTotalPage(newPageNumber) {
    totalPages = newPageNumber;
    notifyListeners();
  }

  setDefault() {
    followedUserCampaignList = [];
    currentPage = 1;
    notifyListeners();
  }

  fetchFollowedUserCampaign(context,
      {bool isrefresh = false, required followedUserId}) async {
    if (isrefresh) {
      //making the list empty first to show loading bar (we are showing loading bar while the product list is empty)
      //we are make the list empty when the sub category or brand is selected because then the refresh is true
      followedUserCampaignList = [];
      notifyListeners();

      Provider.of<FollowedUserCampaignService>(context, listen: false)
          .setCurrentPage(currentPage);
    } else {}

    var connection = await checkConnection();
    if (connection) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        // "Content-Type": "application/json"
        "Authorization": "Bearer $token",
      };

      print('followed user id $followedUserId');

      var response = await http.get(
          Uri.parse(
              "$baseApi/user/donation/followed-user-campaign/$followedUserId?page=$currentPage"),
          headers: header);

      if ((response.statusCode >= 200 && response.statusCode < 300) &&
          jsonDecode(response.body)['data']['data'].isNotEmpty) {
        var modelData =
            FollowedUserCampaignModel.fromJson(jsonDecode(response.body));

        setTotalPage(modelData.data.lastPage);

        if (isrefresh) {
          print('refresh true');
          //if refreshed, then remove all service from list and insert new data
          followedUserCampaignList = [];
          followedUserCampaignList = modelData.data.data.data;
          notifyListeners();
        } else {
          print('add new data');

          //else add more data to list
          for (int i = 0; i < modelData.data.data.data.length; i++) {
            followedUserCampaignList.add(modelData.data.data.data[i]);
          }
          notifyListeners();
        }

        currentPage++;
        setCurrentPage(currentPage);
        return true;
      } else {
        print('followed user campaign fetching error ${response.body}');

        if (followedUserCampaignList.isEmpty) {
          hasData = false;
          notifyListeners();
        }

        Future.delayed(const Duration(microseconds: 700), () {
          hasData = true;
        });
        return false;
      }
    }
  }
}
