// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/event_book_pay_service.dart';
import 'package:fundorex/service/pay_services/payment_choose_service.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/constant_colors.dart';

class BillplzPayment extends StatelessWidget {
  BillplzPayment(
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
          title: const Text('BillPlz'),
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
                    onPageStarted: (String url) {},
                    onPageFinished: (String url) {
                      verifyPayment(url, context, isFromEventBook);
                    },
                    onWebResourceError: (WebResourceError error) {},
                    onNavigationRequest: (NavigationRequest request) {
                      if (request.url.contains("paid%5D=true") &&
                          request.url.contains("http://www.xgenious.com")) {
                        if (isFromEventBook == true) {
                          Provider.of<EventBookPayService>(context,
                                  listen: false)
                              .makePaymentSuccess(context);
                        } else {
                          Provider.of<DonateService>(context, listen: false)
                              .makePaymentSuccess(context);
                        }
                        return NavigationDecision.prevent;
                      }
                      if (request.url.contains("paid%5D=false") &&
                          request.url.contains("http://www.xgenious.com")) {
                        return NavigationDecision.prevent;
                      }
                      return NavigationDecision.navigate;
                    },
                  ),
                );
              return WebViewWidget(controller: _controller);
            }),
      ),
    );
  }

  waitForIt(BuildContext context) async {
    // String orderId =
    //     Provider.of<PlaceOrderService>(context, listen: false).orderId;

    final url = Uri.parse('https://www.billplz-sandbox.com/api/v3/bills');
    final username =
        Provider.of<PaymentChooseService>(context, listen: false).publicKey ??
            '';

    final collectionName =
        Provider.of<PaymentChooseService>(context, listen: false)
                .billPlzCollectionName ??
            '';
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$username'))}';
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": basicAuth,
      // Above is API server key for the Midtrans account, encoded to base64
    };
    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "collection_id": collectionName,
          "description": "Qixer payment",
          "email": email,
          "name": name,
          "amount": "${double.parse(amount) * 100}",
          "reference_1_label": "Bank Code",
          "reference_1": "BP-FKR01",
          "callback_url": "http://www.xgenious.com"
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      this.url = jsonDecode(response.body)["url"];
      return;
    }

    return true;
  }
}

Future verifyPayment(String url, BuildContext context, isFromEventBook) async {
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  if (response.body.contains('paid')) {
    if (isFromEventBook == true) {
      Provider.of<EventBookPayService>(context, listen: false)
          .makePaymentSuccess(context);
    } else {
      Provider.of<DonateService>(context, listen: false)
          .makePaymentSuccess(context);
    }

    return;
  }
  if (response.body.contains('your payment was not')) {
    OthersHelper().showSnackBar(context, 'Payment failed', Colors.red);
    if (isFromEventBook == true) {
      Provider.of<EventBookPayService>(context, listen: false)
          .doNext(context, paymentFailed: true);
    } else {
      Provider.of<DonateService>(context, listen: false)
          .doNext(context, paymentFailed: true);
    }
    return;
  }
}
