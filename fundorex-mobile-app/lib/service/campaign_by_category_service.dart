import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/model/campaign_by_category_model.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CampaignByCategoryService with ChangeNotifier {
  var campaignByCategoryList = [];

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
    campaignByCategoryList = [];
    currentPage = 1;
    notifyListeners();
  }

  fetchCampaignByCategory(context, categoryId, {bool isrefresh = false}) async {
    if (isrefresh) {
      //making the list empty first to show loading bar (we are showing loading bar while the product list is empty)
      //we are make the list empty when the sub category or brand is selected because then the refresh is true
      campaignByCategoryList = [];
      notifyListeners();

      Provider.of<CampaignByCategoryService>(context, listen: false)
          .setCurrentPage(currentPage);
    } else {}

    var connection = await checkConnection();
    if (connection) {
      //if connection is ok
      var response = await http.get(Uri.parse(
          "$baseApi/campaign-by-category/$categoryId?page=$currentPage"));

      print(response.body);
      if ((response.statusCode >= 200 && response.statusCode < 300) &&
          jsonDecode(response.body)['data']['data'].isNotEmpty) {
        var data = CampaignByCategoryModel.fromJson(jsonDecode(response.body));

        setTotalPage(data.data.lastPage);

        if (isrefresh) {
          print('refresh true');
          //if refreshed, then remove all service from list and insert new data
          campaignByCategoryList = [];
          campaignByCategoryList = data.data.data;
          notifyListeners();
        } else {
          print('add new data');

          //else add more data to list
          for (int i = 0; i < data.data.data.length; i++) {
            campaignByCategoryList.add(data.data.data[i]);
          }
          notifyListeners();
        }

        currentPage++;
        setCurrentPage(currentPage);
        return true;
      } else {
        if (campaignByCategoryList.isEmpty) {
          //that means its loading for first time and no data is available
          hasData = false;
          notifyListeners();
          Future.delayed(const Duration(seconds: 1), () {
            hasData = true;
          });
        }
        return false;
      }
    }
  }
}
