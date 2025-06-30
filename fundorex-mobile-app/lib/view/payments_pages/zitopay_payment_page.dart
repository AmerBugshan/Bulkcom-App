// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/event_book_pay_service.dart';
import 'package:fundorex/service/pay_services/payment_choose_service.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/others_helper.dart';

class ZitopayPaymentPage extends StatefulWidget {
  const ZitopayPaymentPage({
    super.key,
    required this.amount,
    required this.name,
    required this.email,
    required this.isFromEventBook,
  });

  final amount;
  final name;
  final email;
  final isFromEventBook;

  @override
  _ZitopayPaymentPageState createState() => _ZitopayPaymentPageState();
}

class _ZitopayPaymentPageState extends State<ZitopayPaymentPage> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.

    zitopayReceiverName =
        Provider.of<PaymentChooseService>(context, listen: false)
            .zitopayReceiverName;
    _controller
      ..loadRequest(Uri.parse(
          "https://zitopay.africa/sci/?currency=XAF&amount=${widget.amount}&receiver=${widget.name}&success_url=https%3A%2F%2Fwww.google.com%2F&cancel_url=https%3A%2F%2Fpub.dev"))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onNavigationRequest: (NavigationRequest request) async {
          if (request.url.contains('https://www.google.com/')) {
            //if payment is success, then the page is refreshing twice.
            //which is causing the screen pop twice.
            //So, this alreadySuccess = true trick will prevent that
            if (alreadySuccessful != true) {
              print('payment success');
              if (widget.isFromEventBook == true) {
                Provider.of<EventBookPayService>(context, listen: false)
                    .makePaymentSuccess(context);
              } else {
                Provider.of<DonateService>(context, listen: false)
                    .makePaymentSuccess(context);
              }
            }

            setState(() {
              alreadySuccessful = true;
            });

            return NavigationDecision.prevent;
          }
          if (request.url.contains('https://pub.dev/')) {
            print('payment failed');
            if (widget.isFromEventBook == true) {
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
  }

  var zitopayReceiverName;

  bool alreadySuccessful = false;

  final WebViewController _controller = WebViewController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (await _controller.canGoBack()) {
            _controller.goBack();
            return false;
          } else {
            await OthersHelper().showPaymentWarning(context,
                isFromEventBook: widget.isFromEventBook);
            return false;
          }
        },
        child: Scaffold(
          appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              backgroundColor: Colors.blue,
              title: const Text("Zitopay"),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: IconButton(
                      onPressed: () async {
                        _controller.reload();
                      },
                      icon: const Icon(Icons.refresh)),
                )
              ]),
          body: WebViewWidget(controller: _controller),
        ),
      ),
    );
  }
}
