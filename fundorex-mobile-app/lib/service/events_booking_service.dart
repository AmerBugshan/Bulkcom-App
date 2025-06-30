// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/model/event_booking_model.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventsBookingService with ChangeNotifier {
  var allBookedEventList = [];

  bool hasData = true;

  late int totalPages;

  int currentPage = 1;

  setCurrentPage(newValue) {
    currentPage = newValue;
    notifyListeners();
  }

  setTotalPage(newPageNumber) {
    totalPages = newPageNumber;
    notifyListeners();
  }

  setDefault() {
    currentPage = 1;
    allBookedEventList = [];
    notifyListeners();
  }

  fetchBookedEvents(context,
      {bool isrefresh = false, fetchBookedListAgain = false}) async {
    if (fetchBookedListAgain == true) {
      setDefault();
    }

    if (isrefresh) {
      //making the list empty first to show loading bar (we are showing loading bar while the product list is empty)
      //we are make the list empty when the sub category or brand is selected because then the refresh is true
      allBookedEventList = [];
      notifyListeners();

      Provider.of<EventsBookingService>(context, listen: false)
          .setCurrentPage(currentPage);
    } else {}

    var connection = await checkConnection();
    if (connection) {
      //if connection is ok

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        // "Content-Type": "application/json"
        "Authorization": "Bearer $token",
      };

      var response = await http.get(
          Uri.parse("$baseApi/user/event/booked-event?page=$currentPage"),
          headers: header);

      if ((response.statusCode >= 200 && response.statusCode < 300) &&
          jsonDecode(response.body)['booked_events']['data'].isNotEmpty) {
        var data = EventBookingModel.fromJson(jsonDecode(response.body));

        setTotalPage(data.bookedEvents.lastPage);

        if (isrefresh) {
          print('refresh true');
          //if refreshed, then remove all service from list and insert new data
          allBookedEventList = [];
          allBookedEventList = data.bookedEvents.data;
          notifyListeners();
        } else {
          print('add new data');

          //else add more data to list
          for (int i = 0; i < data.bookedEvents.data.length; i++) {
            allBookedEventList.add(data.bookedEvents.data[i]);
          }
          notifyListeners();
        }

        currentPage++;
        setCurrentPage(currentPage);
        return true;
      } else {
        print('booked event data fetch error ${response.body}');
        if (allBookedEventList.isEmpty) {
          hasData = false;
          notifyListeners();
        }
        Future.delayed(const Duration(milliseconds: 700), () {
          hasData = true;
        });

        return false;
      }
    }
  }

  //cancel an event
  // ================>

  bool cancelEventLoading = false;

  setCancelEventLoadingTrue() {
    cancelEventLoading = true;
    notifyListeners();
  }

  setCancelEventLoadingFalse() {
    cancelEventLoading = false;
    notifyListeners();
  }

  cancelEvent(BuildContext context, eventId) async {
    print('event id $eventId');
    var connection = await checkConnection();
    if (connection) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        // "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      setCancelEventLoadingTrue();
      var response = await http.get(
        Uri.parse('$baseApi/user/event/event-order/cancel/$eventId'),
        headers: header,
      );
      setCancelEventLoadingFalse();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        fetchBookedEvents(context, fetchBookedListAgain: true);

        OthersHelper()
            .showSnackBar(context, 'Event canceled successfully', Colors.black);

        // Navigator.pop(context);
        return true;
      } else {
        print(response.body);
        OthersHelper().showToast('Something went wrong', Colors.black);
      }
    }
  }
}
