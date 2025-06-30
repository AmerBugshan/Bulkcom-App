// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/model/campaign_details_model.dart';
import 'package:fundorex/model/people_who_donated_model.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/service/follow_user_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CampaignDetailsService with ChangeNotifier {
  var campaignDetails;
  var peopleWhoDonated;

  bool isloading = true;
  bool hasError = false;

  var selectedCampaignId;

  setLoading(bool loading) {
    isloading = loading;
    notifyListeners();
  }

  setErrorStatus(bool newStatus) {
    hasError = newStatus;
    notifyListeners();
  }

  Future<bool> fetchCampaignDetails(
      {required BuildContext context, required campaignId}) async {
    print('campaign id is $campaignId');
    selectedCampaignId = campaignId;

    var connection = await checkConnection();
    if (!connection) {
      if (context.mounted) {
        OthersHelper().showSnackBar(context, 'Check your internet connection',
            ConstantColors().warningColor);
      }
      return false;
    }
    try {
      campaignDetails = null;
      setLoading(true);
      setErrorStatus(false);
      //if connection is ok
      var response =
          await http.get(Uri.parse("$baseApi/campaign-details/$campaignId"));

      //fetch people who donated
      if (context.mounted) {
        fetchPeopleWhoDonated(context: context, campaignId: campaignId);
      }

      setLoading(false);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var data = CampaignDetailsModel.fromJson(jsonDecode(response.body));
        campaignDetails = data;
        notifyListeners();

        //check if followed
        if (context.mounted) {
          Provider.of<FollowUserService>(context, listen: false)
              .checkIfFollowed(context, data.campaignOwnerId);
        }
      } else {
        print('error fetching campaign details ${response.body}');
      }
      return true;
    } catch (e) {
      print('campaign details error: $e');
      setErrorStatus(true);
      if (context.mounted) {
        OthersHelper().showSnackBar(
            context, 'Something went wrong', ConstantColors().warningColor);
      }

      return false;
    }
  }

  //people who donated ========>
  fetchPeopleWhoDonated(
      {required BuildContext context, required campaignId}) async {
    var connection = await checkConnection();
    if (!connection) {
      OthersHelper().showSnackBar(context, 'Check your internet connection',
          ConstantColors().warningColor);
      return;
    }
    // allDonators = [];
    try {
      //if connection is ok
      var response =
          await http.get(Uri.parse("$baseApi/people-who-donated/$campaignId"));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var data = PeopleWhoDonatedModel.fromJson(jsonDecode(response.body));
        peopleWhoDonated = data.peopleWhoDonated.data;
        allDonators = peopleWhoDonated;
        notifyListeners();
      } else {
        print('error fetching people who donated list ${response.body}');
      }
    } catch (e) {
      print('people who donated list error: $e');
    }
  }

  //all people who donated ========>

  var allDonators = [];

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

  fetchAllDonators(
    context, {
    bool isrefresh = false,
  }) async {
    if (isrefresh) {
      //making the list empty first to show loading bar (we are showing loading bar while the product list is empty)
      //we are make the list empty when the sub category or brand is selected because then the refresh is true
      allDonators = [];
      notifyListeners();

      setCurrentPage(1);
    } else {}

    var connection = await checkConnection();
    if (connection) {
      //if connection is ok
      var response = await http.get(Uri.parse(
          "$baseApi/people-who-donated/$selectedCampaignId?page=$currentPage"));

      if ((response.statusCode >= 200 && response.statusCode < 300) &&
          jsonDecode(response.body)['people_who_donated']['data'].isNotEmpty) {
        var data = PeopleWhoDonatedModel.fromJson(jsonDecode(response.body));

        setTotalPage(data.peopleWhoDonated.lastPage);

        if (isrefresh) {
          print('refresh true');
          //if refreshed, then remove all service from list and insert new data
          allDonators = [];
          allDonators = data.peopleWhoDonated.data;
          notifyListeners();
        } else {
          print('add new data');

          //else add more data to list
          for (int i = 0; i < data.peopleWhoDonated.data.length; i++) {
            allDonators.add(data.peopleWhoDonated.data[i]);
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

  //format date
  formatDate(date) {
    var inputDate = DateFormat('dd/MM/yyyy').format(date);

    return inputDate;
  }
}
