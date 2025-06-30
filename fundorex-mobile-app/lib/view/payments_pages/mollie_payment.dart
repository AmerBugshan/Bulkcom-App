// ignore_for_file: avoid_print

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

class MolliePayment extends StatelessWidget {
  MolliePayment(
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
  String? statusURl;
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
          title: const Text('Mollie'),
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
                    onNavigationRequest: (navigation) async {
                      String redirectUrl;

                      if (isFromEventBook == false) {
                        redirectUrl =
                            Provider.of<DonateService>(context, listen: false)
                                .successUrl;
                      } else {
                        redirectUrl = Provider.of<EventBookPayService>(context,
                                listen: false)
                            .successUrl;
                      }
                      var value = navigation.url;
                      if (value.contains(redirectUrl)) {
                        String status = await verifyPayment(context);
                        if (status == 'paid') {
                          if (isFromEventBook == true) {
                            await Provider.of<EventBookPayService>(context,
                                    listen: false)
                                .makePaymentSuccess(context);
                          } else {
                            await Provider.of<DonateService>(context,
                                    listen: false)
                                .makePaymentSuccess(context);
                          }
                          return NavigationDecision.prevent;
                        }
                        if (isFromEventBook == true) {
                          Provider.of<EventBookPayService>(context,
                                  listen: false)
                              .doNext(context, paymentFailed: true);
                        } else {
                          Provider.of<DonateService>(context, listen: false)
                              .doNext(context, paymentFailed: true);
                        }
                        return NavigationDecision.prevent;
                      }
                      if (navigation.url.contains('mollie')) {
                        return NavigationDecision.navigate;
                      }
                      return NavigationDecision.prevent;
                    },
                  ),
                );
              return WebViewWidget(controller: _controller);
            }),
      ),
    );
  }

  waitForIt(BuildContext context) async {
    final publicKey =
        Provider.of<PaymentChooseService>(context, listen: false).publicKey;

    String orderId;
    String successUrl;

    if (isFromEventBook == false) {
      orderId =
          '${Provider.of<DonateService>(context, listen: false).orderId}fundorexDonate';

      successUrl =
          Provider.of<DonateService>(context, listen: false).successUrl;
    } else {
      orderId =
          '${Provider.of<EventBookPayService>(context, listen: false).eventAfterSuccessId}fundorexEvent';
      successUrl =
          Provider.of<EventBookPayService>(context, listen: false).successUrl;
    }

    final url = Uri.parse('https://api.mollie.com/v2/payments');
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $publicKey",
      // Above is API server key for the Midtrans account, encoded to base64
    };

    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "amount": {"value": amount, "currency": "USD"},
          "description": "Qixer payment",
          "redirectUrl": successUrl,
          "webhookUrl": successUrl,
          "metadata": orderId,
          // "method": "creditcard",
        }));
    if (response.statusCode == 201) {
      this.url = jsonDecode(response.body)['_links']['checkout']['href'];
      statusURl = jsonDecode(response.body)['_links']['self']['href'];
      print(statusURl);
      return;
    }

    return true;
  }

  verifyPayment(BuildContext context) async {
    final publicKey =
        Provider.of<PaymentChooseService>(context, listen: false).publicKey;

    final url = Uri.parse(statusURl as String);
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $publicKey",
      // Above is API server key for the Midtrans account, encoded to base64
    };
    final response = await http.get(url, headers: header);
    print(jsonDecode(response.body)['status']);
    return jsonDecode(response.body)['status'];
  }
}
