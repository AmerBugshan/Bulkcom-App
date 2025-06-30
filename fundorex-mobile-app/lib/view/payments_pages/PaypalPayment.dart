// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fundorex/service/pay_services/paypal_service.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../service/donate_service.dart';
import '../../service/event_book_pay_service.dart';
import '../utils/others_helper.dart';

class PaypalPayment extends StatefulWidget {
  final Function onFinish;

  final isFromEventBook;

  const PaypalPayment(
      {super.key,
      required this.onFinish,
      required this.amount,
      required this.name,
      required this.phone,
      required this.email,
      this.isFromEventBook = false});

  final amount;
  final name;
  final phone;
  final email;

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var checkoutUrl;
  var executeUrl;
  var accessToken;
  PaypalService services = PaypalService();

  // you can change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken(context);

        final transactions = getOrderParams(
            widget.amount, widget.name, widget.phone, widget.email);
        final res = await services.createPaypalPayment(
            transactions, accessToken, context);
        setState(() {
          checkoutUrl = res["approvalUrl"];
          executeUrl = res["executeUrl"];
        });
        _controller
          ..loadRequest(Uri.parse(checkoutUrl ?? ''))
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onWebResourceError: (WebResourceError error) async {
              await showDialog(
                  context: context,
                  builder: (ctx) {
                    return const AlertDialog(
                      title: Text('Loading failed!'),
                      content: Text('Failed to load payment page.'),
                    );
                  });
            },
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.contains(returnURL)) {
                final uri = Uri.parse(request.url);
                final payerID = uri.queryParameters['PayerID'];
                if (payerID != null) {
                  services
                      .executePayment(executeUrl, payerID, accessToken)
                      .then((id) {
                    widget.onFinish(id);

                    Navigator.of(context).pop();
                  });
                } else {
                  Navigator.of(context).pop();
                }
                Navigator.of(context).pop();
              }
              if (request.url.contains(cancelURL)) {
                Navigator.of(context).pop();
              }
              return NavigationDecision.navigate;
            },
          ));
      } catch (e) {
        print('exception: $e');
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
              Navigator.pop(context);
            },
          ),
        );
        // ignore: deprecated_member_use
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  // item name, price and quantity
  String itemName = 'Qixer payment';

  int quantity = 1;

  Map<String, dynamic> getOrderParams(amount, name, phone, email) {
    List items = [
      {
        "name": itemName,
        "quantity": quantity,
        "price": amount,
        "currency": defaultCurrency["currency"]
      }
    ];

    // checkout invoice details
    String totalAmount = amount;
    String subTotalAmount = amount;
    // String totalAmount =
    //     Provider.of<BookConfirmationService>(context, listen: false)
    //         .totalPriceAfterAllcalculation
    //         .toString();
    // String subTotalAmount =
    //     Provider.of<BookConfirmationService>(context, listen: false)
    //         .totalPriceAfterAllcalculation
    //         .toString();
    String shippingCost = '0';
    int shippingDiscountCost = 0;
    String userFirstName = name;
    String userLastName = ' ';
    String addressCity = 'Delhi';
    String addressStreet = 'Mathura Road';
    String addressZipCode = '110014';
    String addressCountry = 'India';
    String addressState = 'Delhi';
    String addressPhoneNumber = phone;

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            if (isEnableShipping && isEnableAddress)
              "shipping_address": {
                "recipient_name": "$userFirstName $userLastName",
                "line1": addressStreet,
                "line2": "",
                "city": addressCity,
                "country_code": addressCountry,
                "postal_code": addressZipCode,
                "phone": addressPhoneNumber,
                "state": addressState
              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  final WebViewController _controller = WebViewController();
  @override
  Widget build(BuildContext context) {
    print(checkoutUrl);

    if (checkoutUrl != null) {
      return WillPopScope(
        onWillPop: () async {
          await OthersHelper().showPaymentWarning(context,
              isFromEventBook: widget.isFromEventBook);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Theme.of(context).colorScheme.surface,
            leading: GestureDetector(
              child: const Icon(Icons.arrow_back_ios),
              onTap: () {
                if (widget.isFromEventBook == true) {
                  Provider.of<EventBookPayService>(context, listen: false)
                      .doNext(context, paymentFailed: true);
                } else {
                  Provider.of<DonateService>(context, listen: false)
                      .doNext(context, paymentFailed: true);
                }
              },
            ),
          ),
          body: WebViewWidget(controller: _controller),
        ),
      );
    } else {
      return WillPopScope(
        onWillPop: () async {
          await OthersHelper().showPaymentWarning(context,
              isFromEventBook: widget.isFromEventBook);
          return false;
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            backgroundColor: Colors.black12,
            elevation: 0.0,
          ),
          body: Center(
              child: Container(child: const CircularProgressIndicator())),
        ),
      );
    }
  }
}
