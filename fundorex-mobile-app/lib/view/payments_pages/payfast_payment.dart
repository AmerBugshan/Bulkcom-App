// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fundorex/helper/extension/context_extension.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/event_book_pay_service.dart';
import 'package:fundorex/service/pay_services/payment_choose_service.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/constant_colors.dart';
import '../utils/others_helper.dart';

class PayfastPayment extends StatelessWidget {
  PayfastPayment(
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
  final ValueNotifier<int> progressNotifier = ValueNotifier(0);
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
          title: const Text('Payfast'),
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
                      progressNotifier.value = progress;
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
                      if (value.contains('finish')) {
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
                          Provider.of<EventBookPayService>(context,
                                  listen: false)
                              .doNext(context, paymentFailed: true);
                        } else {
                          Provider.of<DonateService>(context, listen: false)
                              .doNext(context, paymentFailed: true);
                        }
                      }
                    },
                  ),
                );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder(
                    valueListenable: progressNotifier,
                    builder: (context, value, child) => value == 100
                        ? SizedBox()
                        : Container(
                            width: context.width * (value / 100),
                            height: 8,
                            color: cc.primaryColor,
                          ),
                  ),
                  Expanded(child: WebViewWidget(controller: _controller)),
                ],
              );
            }),
      ),
    );
  }

  waitForIt(BuildContext context) {
    final merchantId =
        Provider.of<PaymentChooseService>(context, listen: false).publicKey;

    final merchantKey =
        Provider.of<PaymentChooseService>(context, listen: false).secretKey;

    // final merchantId = '10024000';

    // final merchantKey = '77jcu5v4ufdod';

    url =
        'https://sandbox.payfast.co.za/eng/process?merchant_id=$merchantId&merchant_key=$merchantKey&amount=$amount&item_name=GrenmartGroceries';
    //   return;
    // }

    // return true;
  }

  Future<bool> verifyPayment(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.body.contains('successful'));
    return response.body.contains('successful');
  }
}
