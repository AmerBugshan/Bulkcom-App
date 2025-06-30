import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/model/related_campaign_model.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:http/http.dart' as http;

class RelatedCampaignService with ChangeNotifier {
  List relatedCampaignList = [];

  fetchFeaturedCampaign() async {
    //==============>

    relatedCampaignList = [];
    notifyListeners();

    var connection = await checkConnection();
    if (connection) {
      //if connection is ok
      var response =
          await http.get(Uri.parse('$baseApi/donation?type=feature'));

      try {
        if (response.statusCode >= 200 && response.statusCode < 300) {
          var data = RelatedCampaignModel.fromJson(jsonDecode(response.body));
          relatedCampaignList = data.relatedCampaign.data;
          notifyListeners();
        } else {
          //Something went wrong
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
