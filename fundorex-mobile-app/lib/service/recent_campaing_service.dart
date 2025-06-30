import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/model/recent_campaign_model.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class RecentCampaignService with ChangeNotifier {
  List recentCampaignList = [];
  bool hasError = false;
  fetchRecentCampaign() async {
    if (recentCampaignList.isNotEmpty) return;

    //==============>

    var connection = await checkConnection();
    if (!connection) return;

    try {
      var response = await http.get(Uri.parse('$baseApi/donation?type=recent'));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        hasError = false;
        var data = RecentCampaignModel.fromJson(jsonDecode(response.body));
        recentCampaignList = data.donationRecent.data.data;
        notifyListeners();
      } else {
        //Something went wrong
        hasError = true;
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //All  feature campaign service
  var allRecentCampaign = [];

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

  fetchAllRecentCampaign(context, {bool isrefresh = false}) async {
    if (isrefresh) {
      //making the list empty first to show loading bar (we are showing loading bar while the product list is empty)
      //we are make the list empty when the sub category or brand is selected because then the refresh is true
      allRecentCampaign = [];
      notifyListeners();

      Provider.of<RecentCampaignService>(context, listen: false)
          .setCurrentPage(currentPage);
    } else {}

    var connection = await checkConnection();
    if (connection) {
      //if connection is ok
      var response = await http
          .get(Uri.parse("$baseApi/donation?type=recent&page=$currentPage"));

      if ((response.statusCode >= 200 && response.statusCode < 300) &&
          jsonDecode(response.body)['donation_recent']['data'].isNotEmpty) {
        var data = RecentCampaignModel.fromJson(jsonDecode(response.body));

        setTotalPage(data.donationRecent.lastPage);

        if (isrefresh) {
          print('refresh true');
          //if refreshed, then remove all service from list and insert new data
          allRecentCampaign = [];
          allRecentCampaign = data.donationRecent.data.data;
          notifyListeners();
        } else {
          print('add new data');

          //else add more data to list
          for (int i = 0; i < data.donationRecent.data.data.length; i++) {
            allRecentCampaign.add(data.donationRecent.data.data[i]);
          }
          notifyListeners();
        }

        currentPage++;
        setCurrentPage(currentPage);
        return true;
      } else {
        return false;
      }
    }
  }
}
