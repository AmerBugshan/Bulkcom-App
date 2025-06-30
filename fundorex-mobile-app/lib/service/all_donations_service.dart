// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/model/all_donations_model.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllDonationsService with ChangeNotifier {
  var allDonations = [];

  bool hasDonation = true;

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
    currentPage = 1;
    allDonations = [];
    notifyListeners();
  }

  fetchAllDonations(context, {bool isrefresh = false}) async {
    if (isrefresh) {
      //making the list empty first to show loading bar (we are showing loading bar while the product list is empty)
      //we are make the list empty when the sub category or brand is selected because then the refresh is true
      allDonations = [];
      notifyListeners();

      Provider.of<AllDonationsService>(context, listen: false)
          .setCurrentPage(currentPage);
    } else {}

    var connection = await checkConnection();
    if (!connection) {
      OthersHelper().showSnackBar(
          context,
          'Please check your internet connection',
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
    var response = await http.get(
        Uri.parse("$baseApi/user/donation?page=$currentPage"),
        headers: header);

    if ((response.statusCode >= 200 && response.statusCode < 300) &&
        jsonDecode(response.body)['donations']['data'].isNotEmpty) {
      var data = AllDonationsModel.fromJson(jsonDecode(response.body));

      setTotalPage(data.donations.lastPage);

      if (isrefresh) {
        print('refresh true');
        //if refreshed, then remove all service from list and insert new data
        allDonations = [];
        allDonations = data.donations.data;
        notifyListeners();
      } else {
        print('add new data');

        //else add more data to list
        for (int i = 0; i < data.donations.data.length; i++) {
          allDonations.add(data.donations.data[i]);
        }
        notifyListeners();
      }

      currentPage++;
      setCurrentPage(currentPage);
      return true;
    } else {
      if (allDonations.isEmpty) {
        print('no donation');
        hasDonation = false;
        notifyListeners();
      }

      Future.delayed(const Duration(seconds: 1), () {
        hasDonation = true;
      });
      return false;
    }
  }
}
