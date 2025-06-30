import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/event_book_pay_service.dart';
import 'package:fundorex/service/pay_services/payment_choose_service.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaystackPaymentPage extends StatelessWidget {
  PaystackPaymentPage(
      {super.key,
      required this.amount,
      required this.name,
      required this.email,
      required this.isFromEventBook,
      required this.orderId});

  final amount;
  final name;
  final email;
  final isFromEventBook;
  final orderId;

  String? url;
  final WebViewController _controller = WebViewController();
  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return WillPopScope(
      onWillPop: () async {
        if (isFromEventBook == true) {
          Provider.of<EventBookPayService>(context, listen: false)
              .doNext(context, paymentFailed: true);
        } else {
          Provider.of<DonateService>(context, listen: false)
              .doNext(context, paymentFailed: true);
        }

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            title: const Text('Paystack')),
        body: WillPopScope(
          onWillPop: () async {
            await OthersHelper()
                .showPaymentWarning(context, isFromEventBook: isFromEventBook);
            return false;
          },
          child: FutureBuilder(
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
                          Provider.of<EventBookPayService>(context,
                                  listen: false)
                              .doNext(context, paymentFailed: true);
                        } else {
                          Provider.of<DonateService>(context, listen: false)
                              .doNext(context, paymentFailed: true);
                        }
                      },
                      onPageFinished: (value) async {
                        // final title = await _controller.currentUrl();
                        // print(title);
                        print('on finished.........................$value');
                        final uri = Uri.parse(value);
                        final response = await http.get(uri);
                        // if (response.body.contains('PAYMENT ID')) {

                        if (response.body.contains('Payment Successful')) {
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
                        if (response.body.contains('Declined')) {
                          await showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: const Text('Payment failed!'),
                                  content:
                                      const Text('Payment has been cancelled.'),
                                  actions: [
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        'Ok',
                                        style:
                                            TextStyle(color: cc.primaryColor),
                                      ),
                                    )
                                  ],
                                );
                              });
                        }
                      },
                      onNavigationRequest: (navRequest) async {
                        print(
                            'nav req to .......................${navRequest.url}');
                        if (navRequest.url.contains('success')) {
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
                        if (navRequest.url.contains('failed')) {
                          if (isFromEventBook == true) {
                            Provider.of<EventBookPayService>(context,
                                    listen: false)
                                .doNext(context, paymentFailed: true);
                          } else {
                            Provider.of<DonateService>(context, listen: false)
                                .doNext(context, paymentFailed: true);
                          }
                        }
                        return NavigationDecision.navigate;
                      },
                    ),
                  );
                return WebViewWidget(controller: _controller);
              }),
        ),
      ),
    );
  }

  Future<void> waitForIt(BuildContext context) async {
    final uri = Uri.parse('https://api.paystack.co/transaction/initialize');

    String paystackSecretKey =
        Provider.of<PaymentChooseService>(context, listen: false).secretKey ??
            '';

    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $paystackSecretKey",
      // Above is API server key for the Midtrans account, encoded to base64
    };

    // final orderId = Random().nextInt(23000).toInt();
    final response = await http.post(uri,
        headers: header,
        body: jsonEncode({
          "amount": num.parse(amount.toString()).toInt() * 100,
          "currency": "NGN",
          "email": "tester@gmail.com",
          "reference_id": orderId.toString(),
          "callback_url": "http://success.com",
          "metadata": {"cancel_action": "http://failed.com"}
        }));
    debugPrint(jsonEncode({
      "amount": amount,
      "currency": "NGN",
      "email": email,
      "reference_id": orderId.toString(),
      "callback_url": "http://success.com",
      "metadata": {"cancel_action": "http://failed.com"}
    }).toString());
    print(response.body);
    if (response.statusCode == 200) {
      url = jsonDecode(response.body)['data']['authorization_url'];
      print(url);
      return;
    }

    // print(response.statusCode);
    // if (response.statusCode == 201) {
    // this.url =
    //     'https://sandbox.payfast.co.za/eng/process?merchant_id=${selectedGateaway.merchantId}&merchant_key=${selectedGateaway.merchantKey}&amount=$amount&item_name=GrenmartGroceries';
    // //   return;
    // // }

    // return true;
  }

  Future<bool> verifyPayment(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.body.contains('Payment Completed'));
    return response.body.contains('Payment Completed');
  }
}
