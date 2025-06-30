import 'package:flutter/material.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/event_book_pay_service.dart';
import 'package:fundorex/service/pay_services/payment_choose_service.dart';
import 'package:provider/provider.dart';

class FlutterwaveService {
  String currency = 'USD';

  payByFlutterwave(BuildContext context,
      {required isFromEventBook, required String phone}) {
    _handlePaymentInitialization(context,
        isFromEventBook: isFromEventBook, phone: phone);
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (BuildContext context) => const FlutterwavePaymentPage(),
    //   ),
    // );
  }

  _handlePaymentInitialization(BuildContext context,
      {required isFromEventBook, required String phone}) async {
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

    // String publicKey = 'FLWPUBK_TEST-86cce2ec43c63e09a517290a8347fcab-X';
    String publicKey =
        Provider.of<PaymentChooseService>(context, listen: false).publicKey ??
            '';

    // final style = FlutterwaveStyle(
    //   appBarText: "Flutterwave payment",
    //   buttonColor: Colors.blue,
    //   buttonTextStyle: const TextStyle(
    //     color: Colors.white,
    //     fontSize: 16,
    //   ),
    //   appBarColor: Colors.blue,
    //   dialogCancelTextStyle: const TextStyle(
    //     color: Colors.grey,
    //     fontSize: 17,
    //   ),
    //   dialogContinueTextStyle: const TextStyle(
    //     color: Colors.blue,
    //     fontSize: 17,
    //   ),
    //   mainBackgroundColor: Colors.white,
    //   mainTextStyle:
    //       const TextStyle(color: Colors.black, fontSize: 17, letterSpacing: 2),
    //   dialogBackgroundColor: Colors.white,
    //   appBarIcon: const Icon(Icons.arrow_back, color: Colors.white),
    //   buttonText:
    //       "Pay ${Provider.of<RtlService>(context, listen: false).currency} $amount",
    //   appBarTitleTextStyle: const TextStyle(
    //     color: Colors.white,
    //     fontSize: 18,
    //   ),
    // );

    // final Customer customer =
    //     Customer(name: "FLW Developer", phoneNumber: phone, email: email);

    // final subAccounts = [
    //   SubAccount(
    //       id: "RS_1A3278129B808CB588B53A14608169AD",
    //       transactionChargeType: "flat",
    //       transactionPercentage: 25),
    //   SubAccount(
    //       id: "RS_C7C265B8E4B16C2D472475D7F9F4426A",
    //       transactionChargeType: "flat",
    //       transactionPercentage: 50)
    // ];

    // final Flutterwave flutterwave = Flutterwave(
    //     context: context,
    //     style: style,
    //     publicKey: publicKey,
    //     currency: currency,
    //     txRef: const Uuid().v1(),
    //     amount: amount,
    //     customer: customer,
    //     subAccounts: subAccounts,
    //     paymentOptions: "card, payattitude",
    //     customization: Customization(title: "Test Payment"),
    //     redirectUrl: "https://www.google.com",
    //     isTestMode: false);
    // var response = await flutterwave.charge().catchError(() {
    if (isFromEventBook == true) {
      Provider.of<EventBookPayService>(context, listen: false)
          .doNext(context, paymentFailed: true);
    } else {
      Provider.of<DonateService>(context, listen: false)
          .doNext(context, paymentFailed: true);
    }
    // });
    // showLoading(response.status!, context);

    // print('flutterwave payment successfull');
    // if (isFromEventBook == true) {
    //   Provider.of<EventBookPayService>(context, listen: false)
    //       .makePaymentSuccess(context);
    // } else {
    //   Provider.of<DonateService>(context, listen: false)
    //       .makePaymentSuccess(context);
    // }
    return;

    // print("${response.toJson()}");
  }

  Future<void> showLoading(String message, context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Text(message),
          ),
        );
      },
    );
  }
}
