import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/model/featured_campaign_model.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:http/http.dart' as http;

class FeaturedCampaignService with ChangeNotifier {
  List featuredList = [];
  bool hasError = false;
  bool isLoading = false;

  fetchFeaturedCampaign() async {
    if (featuredList.isNotEmpty) return;

    //==============>

    var connection = await checkConnection();
    if (!connection) return;

    try {
      var response =
          await http.get(Uri.parse('$baseApi/donation?type=feature'));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        hasError = false;
        var data = FeatureCampaignModel.fromJson(jsonDecode(response.body));
        featuredList = data.donationFeature.data.data;
        notifyListeners();
      } else {
        //Something went wrong
        hasError = true;
        notifyListeners();
      }
    } catch (e) {
      hasError = true;
      notifyListeners();
      print(e.toString());
    }
  }

  //All  feature campaign service
  var allFeaturedCampaign = [];

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

  fetchAllFeaturedCampaign(context, {bool isrefresh = false}) async {
    if (isrefresh) {
      //making the list empty first to show loading bar (we are showing loading bar while the product list is empty)
      //we are make the list empty when the sub category or brand is selected because then the refresh is true
      allFeaturedCampaign = [];

      setCurrentPage(1);
    } else {}

    var connection = await checkConnection();
    if (connection) {
      //if connection is ok
      var response = await http
          .get(Uri.parse("$baseApi/donation?type=feature&page=$currentPage"));
      try {
        if ((response.statusCode >= 200 && response.statusCode < 300) &&
            jsonDecode(response.body)['donation_feature']['data'].isNotEmpty) {
          var data = FeatureCampaignModel.fromJson(jsonDecode(response.body));

          setTotalPage(data.donationFeature.lastPage);

          if (isrefresh) {
            print('refresh true');
            //if refreshed, then remove all service from list and insert new data
            allFeaturedCampaign = [];
            allFeaturedCampaign = data.donationFeature.data.data;
            notifyListeners();
          } else {
            print('add new data');

            //else add more data to list
            for (int i = 0; i < data.donationFeature.data.data.length; i++) {
              allFeaturedCampaign.add(data.donationFeature.data.data[i]);
            }
            notifyListeners();
          }

          currentPage++;
          hasError = allFeaturedCampaign.isEmpty;
          setCurrentPage(currentPage);
          return true;
        } else {
          hasError = allFeaturedCampaign.isEmpty;
          return false;
        }
      } catch (e) {
        hasError = allFeaturedCampaign.isEmpty;
        notifyListeners();
      }
    }
  }
}
