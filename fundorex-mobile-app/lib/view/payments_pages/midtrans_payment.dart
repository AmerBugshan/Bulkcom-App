// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/event_book_pay_service.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/constant_colors.dart';
import '../utils/others_helper.dart';

class MidtransPayment extends StatelessWidget {
  MidtransPayment(
      {super.key,
      required this.amount,
      required this.name,
      required this.phone,
      required this.email,
      required this.isFromEventBook});

  final amount;
  final name;
  final phone;
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
          title: const Text('Midtrans'),
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
                    onPageFinished: (value) async {
                      if (value.contains('success')) {
                        if (isFromEventBook == true) {
                          Provider.of<EventBookPayService>(context,
                                  listen: false)
                              .makePaymentSuccess(context);
                        } else {
                          Provider.of<DonateService>(context, listen: false)
                              .makePaymentSuccess(context);
                        }
                        return;
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
    final url =
        Uri.parse('https://app.sandbox.midtrans.com/snap/v1/transactions');

    const serverKey = 'SB-Mid-server-9z5jztsHyYxEdSs7DgkNg2on';
    const clientKey = 'SB-Mid-client-iDuy-jKdZHkLjL_I';

    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$serverKey:$clientKey'))}';
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": basicAuth,
      // Above is API server key for the Midtrans account, encoded to base64
    };
    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "transaction_details": {
            "order_id": DateTime.now().toString(),
            "gross_amount": 100
          },
          "credit_card": {"secure": true},
          "customer_details": {
            "first_name": name,
            "email": email,
            "phone": phone,
          }
        }));
    print(response.statusCode);
    if (response.statusCode == 201) {
      this.url = jsonDecode(response.body)['redirect_url'];
      return;
    }

    return true;
  }
}
