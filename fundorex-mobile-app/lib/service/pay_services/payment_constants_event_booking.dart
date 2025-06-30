// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fundorex/service/event_book_pay_service.dart';
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

randomOrderId() {
  var rng = Random();
  return rng.nextInt(100).toString();
}

payActionForEventBook(
  String method,
  BuildContext context,
  imagePath, {
  required name,
  required email,
  required eventId,
  required qty,
  required String phone,
}) {
  //to know method names visit PaymentGatewayListService class where payment
  //methods list are fetching with method name

  switch (method) {
    case 'paypal':
      makePaymentToGetEventId(context, () {
        PaypalService()
            .payByPaypal(context, isFromEventBook: true, phone: phone);
      },
          selectedPaymentName: method,
          name: name,
          email: email,
          phone: phone,
          eventId: eventId,
          qty: qty);
      break;
    case 'cashfree':
      makePaymentToGetEventId(context, () {
        CashfreeService()
            .getTokenAndPay(context, isFromEventBook: true, phone: phone);
      },
          selectedPaymentName: method,
          name: name,
          email: email,
          phone: phone,
          eventId: eventId,
          qty: qty);
      break;
    case 'flutterwave':
      makePaymentToGetEventId(context, () {
        FlutterwaveService()
            .payByFlutterwave(context, isFromEventBook: true, phone: phone);
      },
          selectedPaymentName: method,
          name: name,
          email: email,
          phone: phone,
          eventId: eventId,
          qty: qty);
      break;
    case 'instamojo':
      makePaymentToGetEventId(context, () {
        InstamojoService().payByInstamojo(context, isFromEventBook: true);
      },
          selectedPaymentName: method,
          name: name,
          email: email,
          phone: phone,
          eventId: eventId,
          qty: qty);
      break;
    case 'marcadopago':
      makePaymentToGetEventId(context, () {
        MercadoPagoService().payByMercado(context, isFromEventBook: true);
      },
          selectedPaymentName: method,
          name: name,
          email: email,
          phone: phone,
          eventId: eventId,
          qty: qty);
      break;
    case 'midtrans':
      makePaymentToGetEventId(context, () {
        MidtransService()
            .payByMidtrans(context, isFromEventBook: true, phone: phone);
      },
          selectedPaymentName: method,
          name: name,
          email: email,
          phone: phone,
          eventId: eventId,
          qty: qty);

      break;
    case 'mollie':
      makePaymentToGetEventId(context, () {
        MollieService().payByMollie(context, isFromEventBook: true);
      },
          selectedPaymentName: method,
          name: name,
          email: email,
          phone: phone,
          eventId: eventId,
          qty: qty);

      break;
    case 'payfast':
      makePaymentToGetEventId(context, () {
        PayfastService().payByPayfast(context, isFromEventBook: true);
      },
          selectedPaymentName: method,
          name: name,
          email: email,
          phone: phone,
          eventId: eventId,
          qty: qty);

      break;
    case 'paystack':
      makePaymentToGetEventId(context, () {
        PaystackService().payByPaystack(context, isFromEventBook: true);
      },
          selectedPaymentName: method,
          name: name,
          email: email,
          phone: phone,
          eventId: eventId,
          qty: qty);
      break;
    case 'paytm':
      // MercadoPagoService().mercadoPay();

      break;

    case 'squareup':
      makePaymentToGetEventId(context, () {
        SquareService().payBySquare(context, isFromEventBook: true);
      },
          selectedPaymentName: method,
          eventId: eventId,
          name: name,
          email: email,
          phone: phone,
          qty: qty);
      break;

    case 'cinetpay':
      makePaymentToGetEventId(context, () {
        CinetPayService()
            .payByCinetpay(context, isFromEventBook: true, phone: phone);
      },
          selectedPaymentName: method,
          eventId: eventId,
          name: name,
          email: email,
          phone: phone,
          qty: qty);
      break;

    case 'paytabs':
      makePaymentToGetEventId(context, () {
        PaytabsService().payByPaytabs(context, isFromEventBook: true);
      },
          selectedPaymentName: method,
          eventId: eventId,
          name: name,
          email: email,
          phone: phone,
          qty: qty);
      break;

    case 'billplz':
      makePaymentToGetEventId(context, () {
        BillPlzService().payByBillPlz(context, isFromEventBook: true);
      },
          selectedPaymentName: method,
          eventId: eventId,
          name: name,
          email: email,
          phone: phone,
          qty: qty);
      break;

    case 'razorpay':
      makePaymentToGetEventId(context, () {
        RazorpayService()
            .payByRazorpay(context, isFromEventBook: true, phone: phone);
      },
          selectedPaymentName: method,
          name: name,
          email: email,
          phone: phone,
          eventId: eventId,
          qty: qty);
      break;

    case 'stripe':
      makePaymentToGetEventId(context, () async {
        await StripeService().makePayment(context, isFromEventBook: true);
      },
          selectedPaymentName: method,
          name: name,
          email: email,
          phone: phone,
          eventId: eventId,
          qty: qty);
      break;

    case 'zitopay':
      makePaymentToGetEventId(context, () {
        ZitopayService().payByZitopay(context, isFromEventBook: true);
      },
          selectedPaymentName: method,
          name: name,
          email: email,
          phone: phone,
          eventId: eventId,
          qty: qty);
      break;

    case 'manual_payment':
      if (imagePath == null) {
        OthersHelper()
            .showToast('You must upload the cheque image', Colors.black);
      } else {
        Provider.of<EventBookPayService>(context, listen: false).eventPay(
            context, imagePath.path,
            isManualOrCod: true,
            selectedPaymentName: method,
            name: name,
            email: email,
            phone: phone,
            eventId: eventId,
            qty: qty);
      }
      // StripeService().makePayment(context);
      break;
    case 'cash_on_delivery':
      Provider.of<EventBookPayService>(context, listen: false).eventPay(
          context, null,
          isManualOrCod: true,
          selectedPaymentName: method,
          name: name,
          email: email,
          phone: phone,
          eventId: eventId,
          qty: qty);
      break;
    default:
      {
        debugPrint('no method found');
      }
  }
}

makePaymentToGetEventId(BuildContext context, function,
    {required selectedPaymentName,
    required name,
    required email,
    required eventId,
    required qty,
    required String phone}) async {
  var res = await Provider.of<EventBookPayService>(context, listen: false)
      .eventPay(context, null,
          selectedPaymentName: selectedPaymentName,
          name: name,
          email: email,
          phone: phone,
          eventId: eventId,
          qty: qty);

  if (res == true) {
    await function();
    Provider.of<EventBookPayService>(context, listen: false).setLoadingFalse();
  } else {
    print(
        'event place unsuccessfull, visit payment_constant_event_booking.dart file');
  }
}
