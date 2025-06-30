// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/event_book_pay_service.dart';
import 'package:fundorex/service/pay_services/payment_choose_service.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/responsive.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../service/profile_service.dart';
import '../utils/common_helper.dart';
import '../utils/others_helper.dart';

class RazorpayPaymentPage extends StatelessWidget {
  RazorpayPaymentPage({
    super.key,
    required this.amount,
    required this.name,
    required this.phone,
    required this.email,
    required this.isFromEventBook,
  });

  final amount;
  final name;
  final phone;
  final email;
  final isFromEventBook;
  String? url;
  String? paymentID;
  final WebViewController _controller = WebViewController();
  @override
  Widget build(BuildContext context) {
    final pgProvider = Provider.of<PaymentChooseService>(
      context,
      listen: false,
    );
    final piProvider = Provider.of<ProfileService>(context, listen: false);
    return Scaffold(
      appBar: CommonHelper().appbarCommon('Payfast', context, () {
        _handlePaymentError(context);
      }),
      body: WillPopScope(
        onWillPop: () async {
          bool canGoBack = await _controller.canGoBack();
          if (canGoBack) {
            _controller.goBack();
            return false;
          }
          _handlePaymentError(context);
          return false;
        },
        child: FutureBuilder(
          future: waitForIt(
            pgProvider.publicKey,
            pgProvider.secretKey,
            DateTime.now().millisecondsSinceEpoch,
            piProvider.profileDetails.userDetails.name,
            piProvider.profileDetails.userDetails.email,
            piProvider.profileDetails.userDetails.phone,
            amount,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      height: 60,
                      child: OthersHelper().showLoading(cc.primaryColor),
                    ),
                  ),
                ],
              );
            }
            if (snapshot.hasData) {}
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            _controller
              ..loadRequest(Uri.parse(url ?? ''))
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setNavigationDelegate(
                NavigationDelegate(
                  onProgress: (int progress) {},
                  onPageStarted: (String url) async {
                    final uri = Uri.parse(url);
                    final response = await http.get(uri);
                    bool paySuccess = response.body.contains('status":"paid');
                    if (paySuccess) {
                      _handlePaymentSuccess(context);
                    }
                  },
                  onPageFinished: (String url) async {},
                  onWebResourceError: (WebResourceError error) {},
                  onNavigationRequest: (request) {
                    return NavigationDecision.navigate;
                  },
                ),
              );
            return WebViewWidget(controller: _controller);
          },
        ),
      ),
    );
  }

  Future waitForIt(
    apiKey,
    apiSecret,
    orderId,
    userName,
    userEmail,
    userPhone,
    num amount,
  ) async {
    final uri = Uri.parse('https://api.razorpay.com/v1/payment_links');
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}';
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": basicAuth,
    };
    final response = await http.post(
      uri,
      headers: header,
      body: jsonEncode({
        "amount": amount * 100,
        "currency": "INR",
        "accept_partial": false,
        "reference_id": orderId.toString(),
        "description": "Qixer payment",
        "customer": {
          "name": userName,
          "contact": userPhone,
          "email": userEmail,
        },
        "notes": {"policy_name": "Qixer"},
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      url = jsonDecode(response.body)['short_url'];
      paymentID = jsonDecode(response.body)['id'];
      print(url);
      return;
    }
    lnProvider.getString("Something went wrong!").showToast();
    return 'failed';
  }

  void _handlePaymentSuccess(BuildContext context) {
    print("Payment Sucessfull");

    if (isFromEventBook == true) {
      Provider.of<EventBookPayService>(context, listen: false)
          .makePaymentSuccess(context);
    } else {
      Provider.of<DonateService>(context, listen: false)
          .makePaymentSuccess(context);
    }
    //     "${response.orderId} \n${response.paymentId} \n${response.signature}");
  }

  void _handlePaymentError(BuildContext context) {
    print("Payemt Failed");
    Provider.of<DonateService>(context, listen: false).setLoadingFalse();
    if (isFromEventBook == true) {
      Provider.of<EventBookPayService>(context, listen: false)
          .doNext(context, paymentFailed: true);
    } else {
      Provider.of<DonateService>(context, listen: false)
          .doNext(context, paymentFailed: true);
    }
  }
}
