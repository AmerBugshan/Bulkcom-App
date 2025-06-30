// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fundorex/service/pay_services/payment_choose_service.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../service/donate_service.dart';
import '../../service/event_book_pay_service.dart';
import '../utils/constant_colors.dart';

class SquareUpPayment extends StatelessWidget {
  SquareUpPayment(
      {super.key,
      required this.amount,
      required this.name,
      required this.email,
      required this.isFromEventBook});

  final amount;
  final name;
  final email;
  final isFromEventBook;

  final WebViewController _controller = WebViewController();

  String? url;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _controller.canGoBack()) {
          _controller.goBack();
          return false;
        } else {
          await OthersHelper()
              .showPaymentWarning(context, isFromEventBook: isFromEventBook);
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          title: const Text("Square"),
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
                ..setNavigationDelegate(NavigationDelegate(
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
                  onNavigationRequest: (NavigationRequest request) async {
                    print('navigation delegate link ${request.url}');
                    if (request.url.contains('http://www.xgenious.com')) {
                      if (isFromEventBook == true) {
                        await Provider.of<EventBookPayService>(context,
                                listen: false)
                            .makePaymentSuccess(context);
                      } else {
                        await Provider.of<DonateService>(context, listen: false)
                            .makePaymentSuccess(context);
                      }
                      return NavigationDecision.prevent;
                    }
                    if (request.url.contains('https://pub.dev/')) {
                      if (isFromEventBook == true) {
                        Provider.of<EventBookPayService>(context, listen: false)
                            .doNext(context, paymentFailed: true);
                      } else {
                        Provider.of<DonateService>(context, listen: false)
                            .doNext(context, paymentFailed: true);
                      }
                      return NavigationDecision.prevent;
                    }
                    return NavigationDecision.navigate;
                  },
                ));

              return WebViewWidget(controller: _controller);
            }),
      ),
    );
  }

  Future waitForIt(BuildContext context) async {
    final secretKey =
        Provider.of<PaymentChooseService>(context, listen: false).secretKey;

    final locationId = Provider.of<PaymentChooseService>(context, listen: false)
        .squareLocationId;

    // const secretKey =
    //     'EAAAEDsGeASjEG2t6YD1XqJxdyMXEJMS9m50rukk07akibxyMeCTjV2UHwdIsTtl';
    // const locationId = 'LP6DRN3R0SBRF';

    // String orderId =
    //     Provider.of<PlaceOrderService>(context, listen: false).orderId;

    final url = Uri.parse(
        'https://connect.squareupsandbox.com/v2/online-checkout/payment-links');
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": 'Bearer $secretKey',
    };

    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "description": "Qixer payment",
          "idempotency_key": DateTime.now().toString(),
          "quick_pay": {
            "location_id": locationId,
            "name": "Qixer payment",
            "price_money": {"amount": 100, "currency": "USD"}
          },
          "payment_note": "Qixer payment",
          "redirect_url": "https://xgenious.com/",
          "pre_populated_data": {"buyer_email": email}
        }));
    print(response.body);
    if (response.statusCode == 200) {
      this.url = jsonDecode(response.body)['payment_link']['url'];
      print(this.url);
      return url;
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
