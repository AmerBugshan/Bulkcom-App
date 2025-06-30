// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/service/reward_list_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RedeemRewardService with ChangeNotifier {
  var redeemableAmount;

  fetchRedeemableAmount(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var userId = prefs.getInt('userId');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      // "Content-Type": "application/json"
      "Authorization": "Bearer $token",
    };

    //if connection is ok
    try {
      var response = await http.get(
          Uri.parse(
              '$baseApi/user/donation/reward-redeem-available-amount/$userId'),
          headers: header);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        redeemableAmount =
            jsonDecode(response.body)['widrawable_available_amount'];

        notifyListeners();
      } else {
        //Something went wrong
        redeemableAmount = 0;
        notifyListeners();
      }
    } catch (e) {
      print('error checking redeemable amount ${e.toString()}');
    }
  }

  // redeem amount
  //====================>

  bool loadingRedeemSubmit = false;

  redeemSubmit(BuildContext context,
      {required requestedAmount,
      required accountDetails,
      required comment}) async {
    //
    loadingRedeemSubmit = true;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var userId = prefs.getInt('userId');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      // "Content-Type": "application/json"
      "Authorization": "Bearer $token",
    };

    var selectedPayment =
        Provider.of<RewardListService>(context, listen: false).selectedPayment;

    var data = {
      "user_id": userId.toString(),
      "payment_gateway": selectedPayment,
      "withdraw_request_amount": requestedAmount,
      "payment_account_details": accountDetails,
      "additional_comment_by_user": comment
    };

    //if connection is ok

    var response = await http.post(
        Uri.parse('$baseApi/user/donation/reward-redeem-submit'),
        headers: header,
        body: data);

    loadingRedeemSubmit = false;
    notifyListeners();

    final jsonData = jsonDecode(response.body);
    print(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      OthersHelper().showToast(jsonData['msg'], Colors.green);
      Navigator.pop(context);

      notifyListeners();
    } else {
      OthersHelper().showToast(jsonData['msg'], Colors.red);
      //Something went wrong
    }
  }
}
