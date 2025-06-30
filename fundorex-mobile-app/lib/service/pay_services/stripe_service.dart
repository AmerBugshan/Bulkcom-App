// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/event_book_pay_service.dart';
import 'package:fundorex/service/pay_services/payment_choose_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StripeService with ChangeNotifier {
  bool isloading = false;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  Map<String, dynamic>? paymentIntentData;

  displayPaymentSheet(BuildContext context, {required isFromEventBook}) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((newValue) async {
        print('stripe payment successfull');
        if (isFromEventBook == true) {
          Provider.of<EventBookPayService>(context, listen: false)
              .makePaymentSuccess(context);
        } else {
          Provider.of<DonateService>(context, listen: false)
              .makePaymentSuccess(context);
        }

        // print('payment id' + paymentIntentData!['id'].toString());
        // print('payment client secret' +
        //     paymentIntentData!['client_secret'].toString());
        // print('payment amount' + paymentIntentData!['amount'].toString());
        // print('payment intent full data' + paymentIntentData.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());
        // OthersHelper().showToast("Payment Successful", Colors.black);

        //payment successs ================>

        paymentIntentData = null;
      }).onError((error, stackTrace) {
        debugPrint('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
        if (isFromEventBook == true) {
          Provider.of<EventBookPayService>(context, listen: false)
              .doNext(context, paymentFailed: true);
        } else {
          Provider.of<DonateService>(context, listen: false)
              .doNext(context, paymentFailed: true);
        }
      });
    } on StripeException {
      // print('Exception/DISPLAYPAYMENTSHEET==> $e');
      if (isFromEventBook == true) {
        Provider.of<EventBookPayService>(context, listen: false)
            .doNext(context, paymentFailed: true);
      } else {
        Provider.of<DonateService>(context, listen: false)
            .doNext(context, paymentFailed: true);
      }
    } catch (e) {
      debugPrint('$e');
      if (isFromEventBook == true) {
        Provider.of<EventBookPayService>(context, listen: false)
            .doNext(context, paymentFailed: true);
      } else {
        Provider.of<DonateService>(context, listen: false)
            .doNext(context, paymentFailed: true);
      }
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
    // return amount;
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency, context) async {
    //========>

    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      // var header ={
      //       'Authorization':
      //           'Bearer sk_test_51GwS1SEmGOuJLTMs2vhSliTwAGkOt4fKJMBrxzTXeCJoLrRu8HFf4I0C5QuyE3l3bQHBJm3c0qFmeVjd0V9nFb6Z00VrWDJ9Uw',
      //       'Content-Type': 'application/x-www-form-urlencoded'
      //     };
      var header = {
        'Authorization':
            'Bearer ${Provider.of<PaymentChooseService>(context, listen: false).secretKey}',
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      // print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: header);
      // print('Create Intent reponse ===> ${response.body.toString()}');
      // debugPrint("response body is ${response.body}");
      return jsonDecode(response.body);
    } catch (err) {
      debugPrint('err charging user: ${err.toString()}');
    }
  }

  Future<void> makePayment(BuildContext context,
      {required isFromEventBook}) async {
    var amount;
    var name;
    var email;

    if (isFromEventBook == false) {
      final dt = Provider.of<DonateService>(context, listen: false);
      amount = dt.donationAmountWithTips + dt.transactionFeeAmount;

      name = Provider.of<DonateService>(context, listen: false)
          .userEnteredNameWhileDonating;
      email = Provider.of<DonateService>(context, listen: false)
          .userEnteredEmailWhileDonating;
    } else {
      amount =
          Provider.of<EventBookPayService>(context, listen: false).eventPrice;

      amount = double.parse(amount).toStringAsFixed(0);
      name = Provider.of<EventBookPayService>(context, listen: false).name;
      email = Provider.of<EventBookPayService>(context, listen: false).email;
    }

    //Stripe takes only integer value

    try {
      var publishableKey = await StripeService().getStripeKey();
      Stripe.publishableKey = publishableKey;
      Stripe.instance.applySettings();
      paymentIntentData = await createPaymentIntent(amount, 'USD', context);
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  style: ThemeMode.light,
                  merchantDisplayName: name))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet(context, isFromEventBook: isFromEventBook);
    } catch (e, s) {
      debugPrint('exception:$e$s');
      if (isFromEventBook == true) {
        Provider.of<EventBookPayService>(context, listen: false)
            .doNext(context, paymentFailed: true);
      } else {
        Provider.of<DonateService>(context, listen: false)
            .doNext(context, paymentFailed: true);
      }
    }
  }

  //get stripe key ==========>

  Future<String> getStripeKey() async {
    var defaultPublicKey =
        'pk_test_51GwS1SEmGOuJLTMsIeYKFtfAT3o3Fc6IOC7wyFmmxA2FIFQ3ZigJ2z1s4ZOweKQKlhaQr1blTH9y6HR2PMjtq1Rx00vqE8LO0x';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var response = await http
        .post(Uri.parse('$baseApi/user/payment-gateway-list'), headers: header);
    print(response.statusCode);
    if (response.statusCode == 201) {
      var paymentList = jsonDecode(response.body)['gateway_list'];
      var publicKey;

      for (int i = 0; i < paymentList.length; i++) {
        if (paymentList[i]['name'] == 'stripe') {
          publicKey = paymentList[i]['public_key'];
        }
      }
      print('stripe public key is $publicKey');
      if (publicKey == null) {
        return defaultPublicKey;
      } else {
        return publicKey;
      }
    } else {
      //failed loading
      return defaultPublicKey;
    }
  }
}

class StripeFailedAlert extends StatelessWidget {
  const StripeFailedAlert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Payment failed'),
      actions: [
        const Spacer(),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Provider.of<PaymentChooseService>(context, listen: false)
                .setLoadingFalse();
          },
          child: Text(
            'Ok',
            style: TextStyle(color: ConstantColors().primaryColor),
          ),
        )
      ],
    );
  }
}
