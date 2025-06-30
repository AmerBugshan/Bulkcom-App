import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/model/campaign_dropdown_model.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:http/http.dart' as http;

class QuickDonationDropdownService with ChangeNotifier {
  var campaignDropdownList = [];
  var campaignDropdownIndexList = [];
  var selectedCampaign;
  var selectedCampaignId;

  setCampaignValue(value) {
    selectedCampaign = value;
    notifyListeners();
  }

  setCampaignId(value) {
    selectedCampaignId = value;
    notifyListeners();
  }

  bool isLoading = false;

  setLoadingTrue() {
    isLoading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isLoading = false;
    notifyListeners();
  }

  fetchCampaign(BuildContext context) async {
    if (campaignDropdownList.isEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setLoadingTrue();
      });
      var response = await http.get(Uri.parse('$baseApi/donation?type=list'));

      print('quick donation dropdown ${response.body}');
      print('quick donation dropdown status code ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var data = CampaignDropdownModel.fromJson(jsonDecode(response.body));

        int listLength = data.donationList.length;
        int loopLength = listLength > 5 ? 5 : listLength;

        for (int i = 0; i < loopLength; i++) {
          campaignDropdownList.add(data.donationList[i].title);
          campaignDropdownIndexList.add(data.donationList[i].id);
        }

        selectedCampaign = campaignDropdownList[0];
        selectedCampaignId = campaignDropdownIndexList[0];

        notifyListeners();
        // fetchStates(selectedCountryId, context);
      } else {
        //error fetching data
        campaignDropdownList.add('Select Campaign');
        campaignDropdownIndexList.add('0');
        selectedCampaign = 'Select Campaign';
        selectedCampaignId = '0';
        // fetchStates(selectedCountryId, context);
        notifyListeners();
      }
    } else {
      //already loaded from api
    }
  }
}
