// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/event_book_pay_service.dart';
import 'package:fundorex/view/payments_pages/squareup_payment.dart';
import 'package:provider/provider.dart';

class SquareService {
  payBySquare(BuildContext context, {required isFromEventBook}) {
    //========>
    Provider.of<DonateService>(context, listen: false).setLoadingFalse();
    Provider.of<EventBookPayService>(context, listen: false).setLoadingFalse();

    var amount;
    var name;
    var email;

    if (isFromEventBook == false) {
      final dt = Provider.of<DonateService>(context, listen: false);
      amount = dt.donationAmountWithTips + dt.transactionFeeAmount;

      amount = amount.toStringAsFixed(2);
      name = dt.userEnteredNameWhileDonating;
      email = dt.userEnteredEmailWhileDonating;
    } else {
      amount =
          Provider.of<EventBookPayService>(context, listen: false).eventPrice;
      amount = double.parse(amount).toStringAsFixed(2);
      name = Provider.of<EventBookPayService>(context, listen: false).name;
      email = Provider.of<EventBookPayService>(context, listen: false).email;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => SquareUpPayment(
          amount: amount,
          name: name,
          email: email,
          isFromEventBook: isFromEventBook,
        ),
      ),
    );
  }
}
