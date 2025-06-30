// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'package:flutter/material.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/pay_services/billplz_service.dart';
import 'package:fundorex/service/pay_services/cashfree_service.dart';
import 'package:fundorex/service/pay_services/cinetpay_service.dart';
import 'package:fundorex/service/pay_services/flutterwave_service.dart';
import 'package:fundorex/service/pay_services/instamojo_service.dart';
import 'package:fundorex/service/pay_services/mercado_pago_service.dart';
import 'package:fundorex/service/pay_services/midtrans_service.dart';
import 'package:fundorex/service/pay_services/mollie_service.dart';
import 'package:fundorex/service/pay_services/payfast_service.dart';
import 'package:fundorex/service/pay_services/paypal_service.dart';
import 'package:fundorex/service/pay_services/paystack_service.dart';
import 'package:fundorex/service/pay_services/paytabs_service.dart';
import 'package:fundorex/service/pay_services/razorpay_service.dart';
import 'package:fundorex/service/pay_services/square_service.dart';
import 'package:fundorex/service/pay_services/stripe_service.dart';
import 'package:fundorex/service/pay_services/zitopay_service.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

payAction(String method, BuildContext context, imagePath,
    {required campaignId,
    required name,
    required email,
    required anonymousDonate,
    required String phone}) {
  //to know method names visit PaymentGatewayListService class where payment
  //methods list are fetching with method name

  switch (method) {
    case 'paypal':
      makePaymentToGetOrderId(context, () {
        PaypalService()
            .payByPaypal(context, isFromEventBook: false, phone: phone);
      },
          selectedPaymentName: method,
          campaignId: campaignId,
          name: name,
          email: email,
          phone: phone,
          anonymousDonate: anonymousDonate);
      break;
    case 'cashfree':
      makePaymentToGetOrderId(context, () {
        CashfreeService()
            .getTokenAndPay(context, isFromEventBook: false, phone: phone);
      },
          selectedPaymentName: method,
          campaignId: campaignId,
          name: name,
          email: email,
          phone: phone,
          anonymousDonate: anonymousDonate);
      break;
    case 'flutterwave':
      makePaymentToGetOrderId(context, () {
        FlutterwaveService()
            .payByFlutterwave(context, isFromEventBook: false, phone: phone);
      },
          selectedPaymentName: method,
          campaignId: campaignId,
          name: name,
          email: email,
          phone: phone,
          anonymousDonate: anonymousDonate);
      break;
    case 'instamojo':
      makePaymentToGetOrderId(context, () {
        InstamojoService().payByInstamojo(context, isFromEventBook: false);
      },
          selectedPaymentName: method,
          campaignId: campaignId,
          name: name,
          email: email,
          phone: phone,
          anonymousDonate: anonymousDonate);
      break;
    case 'marcadopago':
      makePaymentToGetOrderId(context, () {
        MercadoPagoService().payByMercado(context, isFromEventBook: false);
      },
          selectedPaymentName: method,
          campaignId: campaignId,
          name: name,
          email: email,
          phone: phone,
          anonymousDonate: anonymousDonate);
      break;
    case 'midtrans':
      makePaymentToGetOrderId(context, () {
        MidtransService()
            .payByMidtrans(context, isFromEventBook: false, phone: phone);
      },
          selectedPaymentName: method,
          campaignId: campaignId,
          name: name,
          email: email,
          phone: phone,
          anonymousDonate: anonymousDonate);

      break;
    case 'mollie':
      makePaymentToGetOrderId(context, () {
        MollieService().payByMollie(context, isFromEventBook: false);
      },
          selectedPaymentName: method,
          campaignId: campaignId,
          name: name,
          email: email,
          phone: phone,
          anonymousDonate: anonymousDonate);

      break;
    case 'payfast':
      makePaymentToGetOrderId(context, () {
        PayfastService().payByPayfast(context, isFromEventBook: false);
      },
          selectedPaymentName: method,
          campaignId: campaignId,
          name: name,
          email: email,
          phone: phone,
          anonymousDonate: anonymousDonate);

      break;
    case 'paystack':
      makePaymentToGetOrderId(context, () {
        PaystackService().payByPaystack(context, isFromEventBook: false);
      },
          selectedPaymentName: method,
          campaignId: campaignId,
          name: name,
          email: email,
          phone: phone,
          anonymousDonate: anonymousDonate);

      break;
    case 'paytm':
      // MercadoPagoService().mercadoPay();

      break;
    case 'squareup':
      makePaymentToGetOrderId(context, () {
        SquareService().payBySquare(context, isFromEventBook: false);
      },
          selectedPaymentName: method,
          campaignId: campaignId,
          name: name,
          email: email,
          phone: phone,
          anonymousDonate: anonymousDonate);
      break;

    case 'cinetpay':
      makePaymentToGetOrderId(context, () {
        CinetPayService()
            .payByCinetpay(context, isFromEventBook: false, phone: phone);
      },
          selectedPaymentName: method,
          campaignId: campaignId,
          name: name,
          email: email,
          phone: phone,
          anonymousDonate: anonymousDonate);
      break;

    case 'paytabs':
      makePaymentToGetOrderId(context, () {
        PaytabsService().payByPaytabs(context, isFromEventBook: false);
      },
          selectedPaymentName: method,
          campaignId: campaignId,
          name: name,
          email: email,
          phone: phone,
          anonymousDonate: anonymousDonate);
      break;

    case 'billplz':
      makePaymentToGetOrderId(context, () {
        BillPlzService().payByBillPlz(context, isFromEventBook: false);
      },
          selectedPaymentName: method,
          campaignId: campaignId,
          name: name,
          email: email,
          phone: phone,
          anonymousDonate: anonymousDonate);
      break;

    case 'razorpay':
      makePaymentToGetOrderId(context, () {
        RazorpayService()
            .payByRazorpay(context, isFromEventBook: false, phone: phone);
      },
          selectedPaymentName: method,
          campaignId: campaignId,
          name: name,
          email: email,
          phone: phone,
          anonymousDonate: anonymousDonate);
      break;

    case 'stripe':
      makePaymentToGetOrderId(context, () async {
        await StripeService().makePayment(context, isFromEventBook: false);
      },
          selectedPaymentName: method,
          campaignId: campaignId,
          name: name,
          email: email,
          phone: phone,
          anonymousDonate: anonymousDonate);
      break;

    case 'zitopay':
      makePaymentToGetOrderId(context, () {
        ZitopayService().payByZitopay(context, isFromEventBook: false);
      },
          selectedPaymentName: method,
          campaignId: campaignId,
          name: name,
          email: email,
          phone: phone,
          anonymousDonate: anonymousDonate);
      break;

    case 'manual_payment':
      if (imagePath == null) {
        OthersHelper()
            .showToast('You must upload the cheque image', Colors.black);
      } else {
        Provider.of<DonateService>(context, listen: false).donatePay(
            context, imagePath.path,
            isManualOrCod: true,
            selectedPaymentName: method,
            campaignId: campaignId,
            name: name,
            email: email,
            phone: phone,
            anonymousDonate: anonymousDonate);
      }
      // StripeService().makePayment(context);
      break;
    case 'cash_on_delivery':
      Provider.of<DonateService>(context, listen: false).donatePay(
          context, null,
          isManualOrCod: true,
          selectedPaymentName: method,
          campaignId: campaignId,
          name: name,
          email: email,
          phone: phone,
          anonymousDonate: anonymousDonate);
      break;
    default:
      {
        debugPrint('not method found');
      }
  }
}

makePaymentToGetOrderId(BuildContext context, function,
    {required selectedPaymentName,
    required campaignId,
    required name,
    required email,
    required phone,
    required anonymousDonate}) async {
  var res = await Provider.of<DonateService>(context, listen: false).donatePay(
      context, null,
      selectedPaymentName: selectedPaymentName,
      campaignId: campaignId,
      name: name,
      email: email,
      phone: phone,
      anonymousDonate: anonymousDonate);

  if (res == true) {
    await function();
    Provider.of<DonateService>(context, listen: false).setLoadingFalse();
  } else {
    print('order place unsuccessfull, visit payment_constants.dart file');
  }
}
