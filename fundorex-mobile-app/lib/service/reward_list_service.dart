// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'common_service.dart';

class RewardListService with ChangeNotifier {
  var paymentDropdownList = [];
  var paymentDropdownIndexList = [];
  var selectedPayment;
  var selectedPaymentId;

  setgatewayValue(value) {
    selectedPayment = value;
    notifyListeners();
  }

  setSelectedgatewayId(value) {
    selectedPaymentId = value;
    notifyListeners();
  }

  Future fetchGatewayList() async {
    //if payment list already loaded, then don't load again
    if (paymentDropdownList.isNotEmpty) {
      return;
    }

    var connection = await checkConnection();
    if (connection) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      var response = await http.get(Uri.parse('$baseApi/payment-gateway-list'),
          headers: header);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var gatewayList = jsonDecode(response.body)['gateway_list'];
        for (int i = 0; i < gatewayList.length; i++) {
          paymentDropdownList.add(removeUnderscore(gatewayList[i]['name']));
          paymentDropdownIndexList.add(gatewayList[i]['name']);
        }
        selectedPayment = removeUnderscore(gatewayList[0]['name']);
        selectedPaymentId = gatewayList[0]['name'];
        notifyListeners();
      } else {
        //something went wrong
        print('payment gateway list fetching error${response.body}');
      }
    } else {
      //internet off
      return false;
    }
  }

  removeUnderscore(value) {
    return value.replaceAll(RegExp('_'), ' ');
  }
}
