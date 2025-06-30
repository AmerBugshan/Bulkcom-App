import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fundorex/model/all_events_model.dart';
import 'package:fundorex/model/event_details_model.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;

class AllEventsService with ChangeNotifier {
  var allEventsList = [];

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

  fetchAllEventsList(context, {isrefresh = false}) async {
    if (isrefresh) {
      //making the list empty first to show loading bar (we are showing loading bar while the product list is empty)
      //we are make the list empty when the sub category or brand is selected because then the refresh is true

      currentPage = 1;
    } else {}
    var connection = await checkConnection();
    if (connection) {
      //if connection is ok
      var response =
          await http.get(Uri.parse("$baseApi/event-list?page=$currentPage"));

      print("$baseApi/event-list?page=$currentPage");
      if ((response.statusCode >= 200 && response.statusCode < 300) &&
          jsonDecode(response.body)['event_list']['data'].isNotEmpty) {
        var data = AllEventsModel.fromJson(jsonDecode(response.body));

        setTotalPage(data.eventList.lastPage);
        if (isrefresh) {
          print('refresh true');
          //if refreshed, then remove all service from list and insert new data
          print(data.eventList.data.length);
          allEventsList = data.eventList.data;
        } else {
          print('add new data');

          //else add more data to list
          for (int i = 0; i < data.eventList.data.length; i++) {
            allEventsList.add(data.eventList.data[i]);
          }
        }
        hasData = allEventsList.isNotEmpty;
        currentPage++;
        // setCurrentPage(currentPage);
        return true;
      } else {
        if (allEventsList.isEmpty) {
          hasData = false;
          notifyListeners();
        }

        Future.delayed(const Duration(microseconds: 700), () {
          hasData = false;
        });
        return false;
      }
    }
  }

  /// event details
  var eventDetails;
  var eventImage;
  bool isloadingDetails = true;

  bool hasDetailsError = false;

  setLoading(bool loading) {
    isloadingDetails = loading;
    notifyListeners();
  }

  fetchEventDetails(BuildContext context, {required eventId}) async {
    //==============>

    var connection = await checkConnection();
    if (!connection) {
      OthersHelper().showSnackBar(context, 'Check your internet connection',
          ConstantColors().warningColor);
      return;
    }

    //if connection is ok

    setLoading(true);

    var response = await http.get(
      Uri.parse('$baseApi/event-single/$eventId'),
    );

    setLoading(false);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var jsonData = EventDetailsModel.fromJson(jsonDecode(response.body));

      eventDetails = jsonData.event;
      eventImage = jsonData.image;
      notifyListeners();
    } else {
      //Something went wrong
      hasDetailsError = true;

      notifyListeners();

      print('error fetching event details ${response.body}');

      Future.delayed(const Duration(microseconds: 700), () {
        hasDetailsError = false;
      });
    }
  }

  // Cancle event
  cancelEvent(BuildContext context, {required eventId}) async {
    //==============>

    var connection = await checkConnection();
    if (!connection) {
      OthersHelper().showSnackBar(context, 'Check your internet connection',
          ConstantColors().warningColor);
      return;
    }

    //if connection is ok

    setLoading(true);

    var response = await http.get(
      Uri.parse('$baseApi/event-single/$eventId'),
    );

    setLoading(false);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var jsonData = EventDetailsModel.fromJson(jsonDecode(response.body));

      eventDetails = jsonData.event;
      notifyListeners();
    } else {
      //Something went wrong
      hasDetailsError = true;

      notifyListeners();

      print('error fetching event details ${response.body}');

      Future.delayed(const Duration(microseconds: 700), () {
        hasDetailsError = false;
      });
    }
  }
}
