// // ignore_for_file: prefer_typing_uninitialized_variables

// import 'package:flutter/material.dart';
// import 'package:fundorex/service/donate_service.dart';
// import 'package:fundorex/service/event_book_pay_service.dart';
// import 'package:provider/provider.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class PaytmPayment extends StatefulWidget {
//   PaytmPayment({Key? key,required this.isFromEventBook}) : super(key: key);

//   final isFromEventBook;
  
//   @override
//   State<PaytmPayment> createState() => _PaytmPaymentState();
// }

// class _PaytmPaymentState extends State<PaytmPayment> {
//   WebViewController? _controller;
//   var successUrl;
//   var failedUrl;

//   @override
//   void initState() {
//     super.initState();
//     if (widget. isFromEventBook == false) {
//       successUrl =
//           Provider.of<DonateService>(context, listen: false).successUrl;
//     } else {
//       successUrl =
//           Provider.of<EventBookPayService>(context, listen: false).successUrl;
//     }
//   }

//   String? html;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Paytm')),
//       body: WebView(
//         onWebViewCreated: (controller) {
//           _controller = controller;

//           var paytmHtmlString =
//               Provider.of<PlaceOrderService>(context, listen: false)
//                   .paytmHtmlForm as String;

//           controller.loadHtmlString(paytmHtmlString);
//         },
//         initialUrl: "url",
//         javascriptMode: JavascriptMode.unrestricted,
//         navigationDelegate: (NavigationRequest request) async {
//           print('current url is ${request.url}');
//           print('success url is $successUrl');
//           print('failed url is $failedUrl');
//           if (request.url.contains(successUrl)) {
//             //if payment is success, then the page is refreshing twice.
//             //which is causing the screen pop twice.
//             //So, this alreadySuccess = true trick will prevent that

//             print('payment success');
//             await Provider.of<PlaceOrderService>(context, listen: false)
//                 .makePaymentSuccess(context);

//             return NavigationDecision.prevent;
//           }
//           if (request.url.contains('order-cancel-static')) {
//             print('payment failed');
//             OthersHelper().showSnackBar(context, 'Payment failed', Colors.red);
//             Navigator.pop(context);

//             return NavigationDecision.prevent;
//           }
//           return NavigationDecision.navigate;
//         },
//       ),
//     );
//   }
// }
