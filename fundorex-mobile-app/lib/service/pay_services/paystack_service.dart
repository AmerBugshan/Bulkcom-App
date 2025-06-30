import 'package:flutter/material.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/event_book_pay_service.dart';
import 'package:fundorex/view/payments_pages/paystack_payment_page.dart';
import 'package:provider/provider.dart';

class PaystackService {
  payByPaystack(BuildContext context, {required isFromEventBook}) {
    //========>
    Provider.of<DonateService>(context, listen: false).setLoadingFalse();
    Provider.of<EventBookPayService>(context, listen: false).setLoadingFalse();

    var amount;
    var name;
    var email;

    String orderId;

    if (isFromEventBook == false) {
      orderId =
          '${Provider.of<DonateService>(context, listen: false).orderId}fundorexDonate';
      final dt = Provider.of<DonateService>(context, listen: false);
      amount = dt.donationAmountWithTips + dt.transactionFeeAmount;
      amount = amount.toStringAsFixed(2);
      name = Provider.of<DonateService>(context, listen: false)
          .userEnteredNameWhileDonating;
      email = Provider.of<DonateService>(context, listen: false)
          .userEnteredEmailWhileDonating;
    } else {
      orderId =
          '${Provider.of<EventBookPayService>(context, listen: false).eventAfterSuccessId}fundorexEvent';

      amount =
          Provider.of<EventBookPayService>(context, listen: false).eventPrice;

      amount = amount.toString();
      name = Provider.of<EventBookPayService>(context, listen: false).name;
      email = Provider.of<EventBookPayService>(context, listen: false).email;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaystackPaymentPage(
          amount: amount,
          name: name,
          email: email,
          isFromEventBook: isFromEventBook,
          orderId: orderId,
        ),
      ),
    );
  }
}
