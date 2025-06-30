// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/event_book_pay_service.dart';
import 'package:fundorex/service/pay_services/payment_choose_service.dart';
import 'package:fundorex/view/payments_pages/PaypalPayment.dart';
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart';
import 'package:provider/provider.dart';

class PaypalService {
  payByPaypal(BuildContext context,
      {required bool isFromEventBook, required String phone}) {
    //========>
    Provider.of<DonateService>(context, listen: false).setLoadingFalse();
    Provider.of<EventBookPayService>(context, listen: false).setLoadingFalse();

    var amount;
    var name;
    var email;

    if (isFromEventBook == false) {
      final dt = Provider.of<DonateService>(context, listen: false);
      amount = dt.donationAmountWithTips + dt.transactionFeeAmount;

      amount = amount.toStringAsFixed(2);
      name = dt.userEnteredNameWhileDonating;
      email = dt.userEnteredEmailWhileDonating;
    } else {
      amount =
          Provider.of<EventBookPayService>(context, listen: false).eventPrice;
      amount = double.parse(amount).toStringAsFixed(2);
      name = Provider.of<EventBookPayService>(context, listen: false).name;
      email = Provider.of<EventBookPayService>(context, listen: false).email;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalPayment(
          onFinish: (number) async {
            print('paypal payment successfull');

            if (isFromEventBook == true) {
              Provider.of<EventBookPayService>(context, listen: false)
                  .makePaymentSuccess(context);
            } else {
              Provider.of<DonateService>(context, listen: false)
                  .makePaymentSuccess(context);
            }
            // payment done
            print('order id: ' + number);
          },
          amount: amount,
          name: name,
          phone: phone,
          email: email,
        ),
      ),
    );
  }

  // change clientId and secret with your own, provided by paypal

  // for getting the access token from Paypal
  Future<String> getAccessToken(BuildContext context) async {
    bool isTestMode =
        Provider.of<PaymentChooseService>(context, listen: false).isTestMode ??
            false;
    String domain = isTestMode
        ? "https://api.sandbox.paypal.com"
        : "https://api.paypal.com";

//  String domain = "https://api.paypal.com"; // for production mode

    String clientId =
        Provider.of<PaymentChooseService>(context, listen: false).publicKey ??
            '';
    String secret =
        Provider.of<PaymentChooseService>(context, listen: false).secretKey ??
            '';

    print('paypal client key $clientId');
    print('paypal secret key $secret');
    try {
      var client = BasicAuthClient(clientId, secret);

      var response = await client.post(
          Uri.parse('$domain/v1/oauth2/token?grant_type=client_credentials'));
      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        return body["access_token"];
      }
      return "0";
    } catch (e) {
      rethrow;
    }
  }

  // for creating the payment request with Paypal
  Future<Map<String, String>> createPaypalPayment(
      transactions, accessToken, BuildContext context) async {
    bool isTestMode =
        Provider.of<PaymentChooseService>(context, listen: false).isTestMode ??
            false;
    String domain = isTestMode
        ? "https://api.sandbox.paypal.com"
        : "https://api.paypal.com";

    try {
      var response = await http.post(Uri.parse("$domain/v1/payments/payment"),
          body: convert.jsonEncode(transactions),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        throw Exception("0");
      } else {
        print(response.body);
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  // for executing the payment transaction
  Future<String> executePayment(url, payerId, accessToken) async {
    try {
      var response = await http.post(Uri.parse(url),
          body: convert.jsonEncode({"payer_id": payerId}),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(response.body);
        print('success');
        print(response.statusCode);
        return body["id"];
      }
      return "0";
    } catch (e) {
      print('payment unsuccessful');
      print('error is ${e.toString()}');
      rethrow;
    }
  }
}
