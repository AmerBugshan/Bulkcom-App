// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/event_book_pay_service.dart';
import 'package:fundorex/service/pay_services/payment_choose_service.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/constant_colors.dart';
import '../utils/others_helper.dart';

class PayTabsPayment extends StatelessWidget {
  PayTabsPayment(
      {super.key,
      required this.amount,
      required this.name,
      required this.email,
      required this.isFromEventBook});

  final amount;
  final name;
  final email;
  final isFromEventBook;

  String? url;
  final WebViewController _controller = WebViewController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await OthersHelper()
            .showPaymentWarning(context, isFromEventBook: isFromEventBook);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          title: const Text('Paytabs'),
        ),
        body: FutureBuilder(
            future: waitForIt(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: SizedBox(
                            height: 60,
                            child:
                                OthersHelper().showLoading(cc.primaryColor))),
                  ],
                );
              }
              _controller
                ..loadRequest(Uri.parse(url ?? ''))
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onProgress: (int progress) {
                      // Update loading bar.
                    },
                    onWebResourceError: (WebResourceError error) {
                      if (isFromEventBook == true) {
                        Provider.of<EventBookPayService>(context, listen: false)
                            .doNext(context, paymentFailed: true);
                      } else {
                        Provider.of<DonateService>(context, listen: false)
                            .doNext(context, paymentFailed: true);
                      }
                    },
                    onPageStarted: (value) async {
                      if (!value.contains('result')) {
                        return;
                      }
                      bool paySuccess = await verifyPayment(value);

                      if (paySuccess) {
                        if (isFromEventBook == true) {
                          await Provider.of<EventBookPayService>(context,
                                  listen: false)
                              .makePaymentSuccess(context);
                        } else {
                          await Provider.of<DonateService>(context,
                                  listen: false)
                              .makePaymentSuccess(context);
                        }
                        return;
                      }
                      if (isFromEventBook == true) {
                        Provider.of<EventBookPayService>(context, listen: false)
                            .doNext(context, paymentFailed: true);
                      } else {
                        Provider.of<DonateService>(context, listen: false)
                            .doNext(context, paymentFailed: true);
                      }
                    },
                  ),
                );
              return WebViewWidget(controller: _controller);
            }),
      ),
    );
  }

  waitForIt(BuildContext context) async {
    String orderId;

    if (isFromEventBook == false) {
      orderId =
          '${Provider.of<DonateService>(context, listen: false).orderId}fundorexDonate';
    } else {
      orderId =
          '${Provider.of<EventBookPayService>(context, listen: false).eventAfterSuccessId}fundorexEvent';
    }

    // String profileId =
    //     Provider.of<PaymentGatewayListService>(context, listen: false)
    //         .paytabProfileId;
    String secretKey =
        Provider.of<PaymentChooseService>(context, listen: false).secretKey;

    print('here');
    final url = Uri.parse('https://secure-global.paytabs.com/payment/request');
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": secretKey,
      // Above is API server key for the Midtrans account, encoded to base64
    };

    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "profile_id": 96698,
          "tran_type": "sale",
          "tran_class": "ecom",
          "cart_id": orderId.toString(),
          "cart_description": "Qixer payment",
          "cart_currency": "USD",
          "cart_amount": amount,
        }));
    print(response.body);
    if (response.statusCode == 200) {
      this.url = jsonDecode(response.body)['redirect_url'];
      print(this.url);
      return;
    }

    return true;
  }

  Future<bool> verifyPayment(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.body.contains('successful'));
    return response.body.contains('successful');
  }
}
