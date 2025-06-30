// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fundorex/service/pay_services/payment_choose_service.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../service/donate_service.dart';
import '../../service/event_book_pay_service.dart';
import '../utils/constant_colors.dart';
import '../utils/others_helper.dart';

class CinetPayPayment extends StatelessWidget {
  CinetPayPayment(
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
          title: const Text('Cinetpay'),
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
                  ),
                );
              return WebViewWidget(controller: _controller);
            }),
      ),
    );
  }

  waitForIt(BuildContext context) async {
    final url = Uri.parse('https://api-checkout.cinetpay.com/v2/payment');
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      // "Authorization":
      //     'Bearer EAAAEOuLQObrVwJvCvoio3H13b8Ssqz1ighmTBKZvIENW9qxirHGHkqsGcPBC1uN',
      // Above is API server key for the Midtrans account, encoded to base64
    };

    String apiKey =
        Provider.of<PaymentChooseService>(context, listen: false).secretKey;

    String siteId =
        Provider.of<PaymentChooseService>(context, listen: false).publicKey;

    // final apiKey = '12912847765bc0db748fdd44.40081707';
    // final siteId = '445160';

    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "apikey": apiKey,
          "site_id": siteId,
          "transaction_id": DateTime.now().toString(),
          "amount": double.parse(amount).toInt(),
          "currency": "USD",
          "alternative_currency": "USD",
          "description": " Qixer Payment ",
          "customer_id": "1",
          "customer_name": name + " first name",
          "customer_surname": name + " surname",
          "customer_email": email,
          "customer_phone_number": phone,
          "customer_address": 'Dhaka',
          "customer_city": "Dhaka",
          "customer_country": "BD",
          "customer_state": "BD",
          "customer_zip_code": "1220",
          "channels": "ALL"
        }));
    print(response.body);
    if (response.statusCode == 200) {
      this.url = jsonDecode(response.body)['data']['payment_url'];
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
