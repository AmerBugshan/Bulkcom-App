import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/responsive.dart';
import 'package:provider/provider.dart';

import '../../service/donate_service.dart';
import '../../service/event_book_pay_service.dart';

class OthersHelper with ChangeNotifier {
  ConstantColors cc = ConstantColors();
  int deliveryCharge = 60;

  showLoading(Color color) {
    return SpinKitThreeBounce(
      color: color,
      size: 16.0,
    );
  }

  showError(BuildContext context, String errorText) {
    return Consumer<AppStringService>(
      builder: (context, ln, child) => Container(
          height: MediaQuery.of(context).size.height - 180,
          alignment: Alignment.center,
          child: Text(ln.getString(errorText))),
    );
  }

  void showToast(String msg, Color? color) {
    Fluttertoast.showToast(
        msg: lnProvider.getString(msg),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  // snackbar
  showSnackBar(BuildContext context, String msg, color) {
    var snackBar = SnackBar(
      content: Text(lnProvider.getString(msg)),
      backgroundColor: color,
      duration: const Duration(milliseconds: 2000),
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void toastShort(String msg, Color color) {
    Fluttertoast.showToast(
        msg: lnProvider.getString(msg),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  showPaymentWarning(context, {isFromEventBook = false}) async {
    final asProvider = Provider.of<AppStringService>(context, listen: false);
    await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(asProvider.getString('Are you sure?')),
            content: Text(asProvider
                .getString('Your payment process will be terminated.')),
            actions: [
              TextButton(
                onPressed: () {
                  if (isFromEventBook == true) {
                    Provider.of<EventBookPayService>(context, listen: false)
                        .doNext(context, paymentFailed: true);
                  } else {
                    Provider.of<DonateService>(context, listen: false)
                        .doNext(context, paymentFailed: true);
                  }
                },
                child: Text(
                  asProvider.getString('Yes'),
                  style: TextStyle(color: cc.primaryColor),
                ),
              )
            ],
          );
        });
  }
}
