// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/event_book_pay_service.dart';
import 'package:fundorex/service/pay_services/payment_choose_service.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/others_helper.dart';

class MercadopagoPaymentPage extends StatefulWidget {
  const MercadopagoPaymentPage(
      {super.key,
      required this.amount,
      required this.name,
      required this.email,
      required this.isFromEventBook});

  final amount;
  final name;
  final email;
  final isFromEventBook;

  @override
  State<MercadopagoPaymentPage> createState() => _MercadopagoPaymentPageState();
}

class _MercadopagoPaymentPageState extends State<MercadopagoPaymentPage> {
  @override
  void initState() {
    super.initState();
  }

  late String url;
  final WebViewController _controller = WebViewController();
  @override
  Widget build(BuildContext context) {
    final cc = ConstantColors();
    return WillPopScope(
      onWillPop: () async {
        await OthersHelper().showPaymentWarning(context,
            isFromEventBook: widget.isFromEventBook);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          title: const Text('Mercado pago'),
        ),
        body: FutureBuilder(
            future: getPaymentUrl(context),
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
                      if (widget.isFromEventBook == true) {
                        Provider.of<EventBookPayService>(context, listen: false)
                            .doNext(context, paymentFailed: true);
                      } else {
                        Provider.of<DonateService>(context, listen: false)
                            .doNext(context, paymentFailed: true);
                      }
                    },
                    onNavigationRequest: (NavigationRequest request) async {
                      if (request.url.contains('https://www.google.com/')) {
                        print('payment success');

                        if (widget.isFromEventBook == true) {
                          Provider.of<EventBookPayService>(context,
                                  listen: false)
                              .makePaymentSuccess(context);
                        } else {
                          Provider.of<DonateService>(context, listen: false)
                              .makePaymentSuccess(context);
                        }

                        return NavigationDecision.prevent;
                      }
                      if (request.url.contains('https://www.facebook.com/')) {
                        print('payment failed');
                        if (widget.isFromEventBook == true) {
                          Provider.of<EventBookPayService>(context,
                                  listen: false)
                              .doNext(context, paymentFailed: true);
                        } else {
                          Provider.of<DonateService>(context, listen: false)
                              .doNext(context, paymentFailed: true);
                        }
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

  Future<dynamic> getPaymentUrl(BuildContext context) async {
    String mercadoKey =
        Provider.of<PaymentChooseService>(context, listen: false).secretKey ??
            '';

    var header = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    };

    var data = jsonEncode({
      "items": [
        {
          "title": "Qixer",
          "description": "Qixer payment",
          "quantity": 1,
          "currency_id": "ARS",
          "unit_price": double.parse(widget.amount).toInt()
        }
      ],
      'back_urls': {
        "success": 'https://www.google.com/',
        "failure": 'https://www.facebook.com',
        "pending": 'https://www.facebook.com'
      },
      'auto_return': 'approved',
      "payer": {"email": widget.email}
    });

    var response = await http.post(
        Uri.parse(
            'https://api.mercadopago.com/checkout/preferences?access_token=$mercadoKey'),
        headers: header,
        body: data);

    print(response.body);

    // print(response.body);
    if (response.statusCode == 201) {
      url = jsonDecode(response.body)['init_point'];

      return;
    }
    return '';
  }
}
