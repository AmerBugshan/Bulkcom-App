import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/model/my_campaign_list_model.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyCampaignListService with ChangeNotifier {
  //All  feature campaign service
  var myCampaignList = [];

  bool isLoading = false;

  bool deleteLoading = false;

  setLoadingStatus(bool status) {
    isLoading = status;
    notifyListeners();
  }

  setDeleteLoadingStatus(bool status) {
    deleteLoading = status;
    notifyListeners();
  }

  fetchMyCampaigns(
    context,
  ) async {
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

      setLoadingStatus(true);

      var response = await http.get(Uri.parse("$baseApi/user/user-campaign"),
          headers: header);

      setLoadingStatus(false);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final modelData =
            MyCampaignListModel.fromJson(jsonDecode(response.body));

        myCampaignList = modelData.allCampaigns;
        notifyListeners();
        return true;
      } else {
        print(response.body);
        return false;
      }
    }
  }

  //delete campaign
  //======================>

  deleteCampaign(campaignId, BuildContext context) async {
    var connection = await checkConnection();
    if (!connection) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      // "Content-Type": "application/json"
      "Authorization": "Bearer $token",
    };

    setDeleteLoadingStatus(true);

    var response = await http.get(
        Uri.parse("$baseApi/user/user-campaign/delete/$campaignId"),
        headers: header);
    setDeleteLoadingStatus(false);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      fetchMyCampaigns(
        context,
      );
      Navigator.pop(context);
    } else {
      OthersHelper()
          .showSnackBar(context, 'Something went wrong', Colors.black);
    }
  }
}
