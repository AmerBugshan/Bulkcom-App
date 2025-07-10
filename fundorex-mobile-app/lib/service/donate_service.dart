// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fundorex/service/all_donations_service.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/service/dashboard_service.dart';
import 'package:fundorex/view/home/homepage.dart';
import 'package:fundorex/view/payment/payment_success_page.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DonateService with ChangeNotifier {
  List amounts = [];
  var successUrl;
  var cancelUrl;

  var userEnteredNameWhileDonating;
  var userEnteredEmailWhileDonating;
  String dTC = "";
  String dPP = "";
  String eTC = "";
  String ePP = "";
  String sTC = "";
  String sPP = "";

  bool isloading = false;

  var orderId;

  var tips;
  var tipsAfterCalculatingPercentage;
  var donationAmount;
  var donationAmountWithTips;

  // what user entered in form while donating
  setUserEnteredNameEmail(name, email) {
    userEnteredNameWhileDonating = name;
    userEnteredEmailWhileDonating = email;
    notifyListeners();
  }

  num get transactionFeeAmount {
    if (transactionFeeType == "percentage") {
      num amount = 0;
      amount = ((donationAmount) * (transactionFee ?? 0)) / 100;
      return amount;
    } else {
      return transactionFee ?? 0;
    }
  }

  // ✅ Fixed Method (Now Supports num & String safely)
  setDonationAmount(dynamic amount) {
    if (amount is num) {
      donationAmount = amount;
    } else {
      donationAmount = num.tryParse(amount.toString()) ?? 0;
    }

    print('set donation fun ran');

    if (chargeDonateFrom != 'donor') {
      donationAmountWithTips = donationAmount;
      notifyListeners();
      return;
    }

    if (tipsAmountType == 'percentage') {
      var newTip = calculateTipsForNewAmount(donationAmount);
      donationAmountWithTips = donationAmount + newTip;
    } else {
      donationAmountWithTips = donationAmount + tips;
    }

    notifyListeners();
  }

  calculateTipsForNewAmount(newAmount) {
    tips = (newAmount / 100) * chargeAmount;
    notifyListeners();
    return tips;
  }

  // Calculate initial tips
  calculateTips({bool isAfterSelectingOrWritingNewAmount = false}) {
    if (tipsAmountType != 'percentage') {
      tips = chargeAmount;
    } else {
      tips = (donationAmount.runtimeType == int
          ? donationAmount
          : int.parse(donationAmount) / 100) *
          chargeAmount;
      print('tips is $tips');
    }

    Future.delayed(const Duration(microseconds: 700), () {
      notifyListeners();
      setDonationAmount(donationAmount);
    });
  }

  calculateInitialDonationAmount() {
    if (defaultDonateAmount != 0) {
      donationAmount = defaultDonateAmount;
    } else {
      donationAmount = amounts[0];
    }

    Future.delayed(const Duration(microseconds: 700), () {
      notifyListeners();
    });
  }

  increaseTips() {
    if (tipsAmountType == 'percentage') {
      chargeAmount = chargeAmount + 10;
    } else {
      tips = tips + 1;
    }

    setDonationAmount(donationAmount.toString());
    notifyListeners();
  }

  decreaseTips() {
    if (tipsAmountType == 'percentage') {
      chargeAmount = chargeAmount - 10;
      if (chargeAmount < 0) {
        chargeAmount = 0.0;
      }
    } else {
      tips = tips - 1;
      if (tips < 0) {
        tips = 0.0;
      }
    }

    setDonationAmount(donationAmount.toString());
    notifyListeners();
  }

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  setDefault() {
    tips = chargeAmount ?? 0;
    donationAmount = int.parse(amounts[0]);
    donationAmountWithTips = donationAmount;
    notifyListeners();
  }

  fetchAmounts(BuildContext context) async {
    if (amounts.isNotEmpty) return;

    var connection = await checkConnection();
    if (!connection) {
      OthersHelper().showSnackBar(context, 'Check your internet connection',
          ConstantColors().warningColor);
      return;
    }

    await Provider.of<DonateService>(context, listen: false)
        .fetchDonateSetting(context);
    var response = await http.get(
      Uri.parse('$baseApi/custom-amounts'),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      amounts = jsonDecode(response.body)['custom_amounts'];
      notifyListeners();
    } else {
      amounts = ['10', '20', '40'];
      notifyListeners();
    }
  }

  var chargeDonateFrom;
  var allowCustomTip;
  var minimumDonateAmount;
  var transactionFeeType;
  num? transactionFee;

  var tipsAmountType;
  var chargeAmount;
  var defaultDonateAmount;
  var chargeActiveButton;

  Future<bool> fetchDonateSetting(BuildContext context) async {
    var response = await http.get(
      Uri.parse('$baseApi/donation-admin-settings'),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var jsonData = jsonDecode(response.body);
      log(response.body.toString());
      chargeDonateFrom = jsonData['donation_charge_from'];
      dTC = jsonData['donation_terms_and_conditions']?.toString() ?? "";
      dPP = jsonData['donation_privacy_policy']?.toString() ?? "";
      eTC = jsonData['event_terms_and_conditions']?.toString() ?? "";
      ePP = jsonData['event_privacy_policy']?.toString() ?? "";
      sTC = jsonData['register_terms_and_conditions']?.toString() ?? "";
      sPP = jsonData['register_privacy_policy']?.toString() ?? "";
      allowCustomTip = jsonData['allow_user_to_add_custom_tip_in_donation'];
      transactionFee = num.tryParse(
          jsonData['transaction_minimum_charge_amount'].toString());
      transactionFeeType =
      (jsonData['transaction_minimum_charge_amount_type']?.toString() ?? "")
          .isEmpty
          ? null
          : jsonData['transaction_minimum_charge_amount_type']?.toString();
      minimumDonateAmount = jsonData['minimum_donation_amount'] != null
          ? num.tryParse(jsonData['minimum_donation_amount'])
          : 0;
      tipsAmountType = jsonData['charge_amount_type'];
      chargeAmount = jsonData['charge_amount'] != null
          ? num.tryParse(jsonData['charge_amount'])
          : 0;
      chargeActiveButton = jsonData['donation_charge_active_deactive_button'];
      defaultDonateAmount = jsonData['donation_default_amount'];
      notifyListeners();
    } else {
      print('error fetching donate setting${response.body}');
    }

    return true;
  }

  Future<bool> donatePay(BuildContext context, String? imagePath,
      {bool isManualOrCod = false,
        required selectedPaymentName,
        required campaignId,
        required name,
        required email,
        required anonymousDonate,
        required phone}) async {
    setLoadingTrue();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var userId = prefs.getInt('userId');

    var formData;
    var dio = Dio();
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Authorization'] = "Bearer $token";

    if (imagePath != null) {
      formData = FormData.fromMap({
        'selected_payment_gateway': selectedPaymentName,
        'cause_id': campaignId,
        'amount': donationAmount,
        'admin_tip': tips,
        'name': name,
        'email': email,
        'phone': phone,
        'user_id': userId,
        'anonymous': anonymousDonate == true ? 1 : 0,
        'manual_payment_attachment': await MultipartFile.fromFile(imagePath,
            filename: 'bankTransfer$name$imagePath.jpg'),
      });
    } else {
      formData = FormData.fromMap({
        'selected_payment_gateway': selectedPaymentName,
        'cause_id': campaignId,
        'amount': donationAmount,
        'admin_tip': tips,
        'name': name,
        'email': email,
        'phone': phone,
        'user_id': userId,
      });
    }

    var response = await dio.post('$baseApi/user/donation/pay',
        data: formData,
        options: Options(
          validateStatus: (status) => true,
        ));

    if ((response.statusCode ?? 0) >= 200 && (response.statusCode ?? 0) < 300) {
      print(response.data);

      orderId = response.data['order_id'];
      successUrl = response.data['success_url'];
      cancelUrl = response.data['cancel_url'];

      notifyListeners();

      if (isManualOrCod == true) {
        doNext(context);
        setLoadingFalse();
      }
      return true;
    } else {
      setLoadingFalse();
      OthersHelper().showToast('حدث خطأ', Colors.black);
      return false;
    }
  }

  Future<bool> makePaymentSuccess(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var connection = await checkConnection();

    if (connection) {
      var header = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      var response = await http.get(
          Uri.parse('$baseApi/user/donation/payment-status-update/$orderId'),
          headers: header);
      setLoadingFalse();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        OthersHelper().showToast('تم الشراء', Colors.black);

        doNext(context);
        return true;
      } else {
        OthersHelper().showToast(
            'Failed to make payment status successfull', Colors.black);
        doNext(context);
        return false;
      }
    } else {
      OthersHelper().showToast(
          'تأكد من إتصالك بالإنترنت', Colors.black);
      return false;
    }
  }

  doNext(BuildContext context, {paymentFailed = false}) {
    Provider.of<DashboardService>(context, listen: false)
        .fetchDashboardData(context);
    Provider.of<AllDonationsService>(context, listen: false).setDefault();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Homepage()),
            (Route<dynamic> route) => false);

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => PaymentSuccessPage(
          paymentFailed: paymentFailed,
        ),
      ),
    );

    setDefault();
  }
}
