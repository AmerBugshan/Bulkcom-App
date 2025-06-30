import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/service/support_ticket/support_ticket_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateTicketService with ChangeNotifier {
  bool isLoading = false;
  //priority dropdown
  var priorityDropdownList = ['Urgent', 'High', 'Medium', 'Low'];
  var priorityDropdownIndexList = ['Urgent', 'High', 'Medium', 'Low'];
  var selectedPriority = 'Urgent';
  var selectedPriorityId = '';

  setPriorityValue(value) {
    selectedPriority = value;
    notifyListeners();
  }

  setSelectedPriorityId(value) {
    selectedPriorityId = value;
    notifyListeners();
  }

  bool hasOrder = true;

  //order list dropdown
  var orderDropdownList = [];
  var orderDropdownIndexList = [];
  var selectedOrder;
  // var selectedOrderId;

  setOrderValue(value) {
    selectedOrder = value;
    notifyListeners();
  }

  setSelectedOrderId(value) {
    // selectedOrderId = value;
    notifyListeners();
  }

  makeOrderlistEmpty() {
    orderDropdownList = [];
    orderDropdownIndexList = [];
    notifyListeners();
  }

  // fetchOrderDropdown(BuildContext context) async {
  //   hasOrder = true;
  //   Future.delayed(const Duration(microseconds: 500), () {
  //     notifyListeners();
  //   });
  //   var orders = await Provider.of<MyOrdersService>(context, listen: false)
  //       .fetchMyOrders();
  //   if (orders != 'error') {
  //     print('orders is $orders');
  //     for (int i = 0; i < orders.length; i++) {
  //       orderDropdownList.add('#${orders[i].id}');
  //       orderDropdownIndexList.add(orders[i].id);
  //     }
  //     selectedOrder = '#${orders[0].id}';
  //     selectedOrderId = orders[0].id;
  //     hasOrder = true;
  //     notifyListeners();
  //   } else {
  //     hasOrder = false;
  //     notifyListeners();
  //   }
  // }

  //create ticket ====>

  createTicket(BuildContext context, subject, priority, desc) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    var token = prefs.getString('token');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var data = jsonEncode({
      'title': subject + ' ',
      'subject': subject,
      'description': desc,
      'status': 'open',
      'priority': priority,
      'user_id': userId
    });

    var connection = await checkConnection();
    if (connection) {
      isLoading = true;
      notifyListeners();
      //if connection is ok
      var response = await http.post(Uri.parse('$baseApi/user/ticket/create'),
          headers: header, body: data);
      isLoading = false;
      notifyListeners();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        OthersHelper().showToast('Ticket created successfully', Colors.black);

        Provider.of<SupportTicketService>(context, listen: false)
            .addNewDataToTicketList(subject,
                jsonDecode(response.body)['ticket']['id'], priority, 'open');
        Navigator.pop(context);
      } else {
        print('error creating ticket ${response.body}');
        OthersHelper().showToast('Something went wrong', Colors.black);
      }
    }
  }
}
