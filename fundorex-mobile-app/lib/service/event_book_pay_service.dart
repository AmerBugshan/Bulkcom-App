// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/service/dashboard_service.dart';
import 'package:fundorex/service/events_booking_service.dart';
import 'package:fundorex/view/home/homepage.dart';
import 'package:fundorex/view/payment/event_payment_success_page.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventBookPayService with ChangeNotifier {
  bool isloading = false;
  var successUrl;
  var cancelUrl;
  String email = "example@gmail.com";
  String phone = "12345678912";
  String name = "User";

  var eventPrice;

  var eventAfterSuccessId;

  setEventPrice(value) {
    eventPrice = value;
    notifyListeners();
  }

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  Future<bool> eventPay(
    BuildContext context,
    String? imagePath, {
    bool isManualOrCod = false,
    required selectedPaymentName,
    required name,
    required email,
    required eventId,
    required qty,
    required String phone,
  }) async {
    setLoadingTrue();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var formData;
    var dio = Dio();
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Authorization'] = "Bearer $token";
    this.email = email;
    this.name = name;
    this.phone = phone;

    //else it is online service. so, some fields will not be given to api
    if (imagePath != null) {
      //if manual transfer selected then image upload is mandatory
      formData = FormData.fromMap({
        'selected_payment_gateway': selectedPaymentName,
        'name': name,
        'email': email,
        "phone": phone,
        'event_id': eventId,
        'quantity': qty,
        'manual_payment_attachment': await MultipartFile.fromFile(imagePath,
            filename: 'bankTransfer$name$imagePath.jpg'),
      });
    } else {
      //other payment method selected
      formData = FormData.fromMap({
        'selected_payment_gateway': selectedPaymentName,
        'name': name,
        'email': email,
        "phone": phone,
        'event_id': eventId,
        'quantity': qty,
      });
    }

    var response = await dio.post('$baseApi/user/event/pay',
        data: formData, options: Options(validateStatus: (_) => true));

    if ((response.statusCode ?? 0) >= 200 && (response.statusCode ?? 0) < 300) {
      successUrl = response.data['success_url'];
      cancelUrl = response.data['cancel_url'];

      print(response.data);

      eventAfterSuccessId = response.data['order_id'];
      print('event id is $eventId');

      notifyListeners();

      if (isManualOrCod == true) {
        //if user placed order in manual transfer or cash on delivery then no need to hit the api- make payment success
        //because in this case payment needs to stay pending anyway.
        doNext(context);
        setLoadingFalse();
      }
      return true;
    } else {
      setLoadingFalse();
      debugPrint("event pay error".toString());
      print(response.data);
      OthersHelper().showToast('Something went wrong', Colors.black);
      return false;
    }

    //
  }

  //make payment successfull
  Future<bool> makePaymentSuccess(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var connection = await checkConnection();

    if (connection) {
      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      var response = await http.get(
          Uri.parse(
              '$baseApi/user/event/payment-status-update/$eventAfterSuccessId'),
          headers: header);
      setLoadingFalse();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        OthersHelper().showToast('Event booked successfully', Colors.black);

        doNext(context);
        return true;
      } else {
        print(response.body);
        OthersHelper().showToast(
            'Failed to make payment status successfull', Colors.black);

        doNext(
          context,
        );
        return false;
      }
    } else {
      OthersHelper().showToast(
          'Check your internet connection and try again', Colors.black);

      return false;
    }
  }

  ///////////==========>
  doNext(BuildContext context, {paymentFailed = false}) {
    // Refresh dashboard data
    Provider.of<DashboardService>(context, listen: false)
        .fetchDashboardData(context);

//to see new data, remove old ones
    Provider.of<EventsBookingService>(context, listen: false).setDefault();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Homepage()),
        (Route<dynamic> route) => false);

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => EventPaymentSuccessPage(
          paymentFailed: paymentFailed,
        ),
      ),
    );
  }
}
