// // ignore_for_file: prefer_typing_uninitialized_variables

// import 'package:flutter/material.dart';
// import 'package:fundorex/service/donate_service.dart';
// import 'package:fundorex/service/event_book_pay_service.dart';
// import 'package:fundorex/view/payments_pages/paytm_payment.dart';
// import 'package:provider/provider.dart';

// class PaytmService {
//   payByPaytm(BuildContext context, {required isFromEventBook}) {
//     //========>
//     Provider.of<DonateService>(context, listen: false).setLoadingFalse();
//     Provider.of<EventBookPayService>(context, listen: false).setLoadingFalse();

//     var amount;

//     if (isFromEventBook == false) {
//       amount = Provider.of<DonateService>(context, listen: false)
//           .donationAmountWithTips;

//       amount = amount.toStringAsFixed(2);
//     } else {
//       amount =
//           Provider.of<EventBookPayService>(context, listen: false).eventPrice;
//       amount = double.parse(amount).toStringAsFixed(2);
//       print(amount);
//     }

//     var name = 'saleheen';
//     var phone = '521212154545';
//     var email = 'xgeniousmobile@gmail.com';
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (BuildContext context) => PaytmPayment(

//         ),
//       ),
//     );
//   }
// }
