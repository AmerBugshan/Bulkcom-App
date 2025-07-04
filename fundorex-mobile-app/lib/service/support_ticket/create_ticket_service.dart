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

  // إنشاء تذكرة
  Future<void> createTicket(
      BuildContext context,
      String title,
      String description,
      String URL,
      ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    String? token = prefs.getString('token');

    var headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var body = jsonEncode({
      'title': title,
      'subject': title,
      'description': description,
      'status': 'open',
      'priority': 'high', // ✅ القيمة الافتراضية
      'user_id': userId,
      'URL': URL, // ✅ إرسال الرابط
    });

    var connection = await checkConnection();
    if (connection) {
      isLoading = true;
      notifyListeners();

      var response = await http.post(
        Uri.parse('$baseApi/user/ticket/create'),
        headers: headers,
        body: body,
      );

      isLoading = false;
      notifyListeners();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        OthersHelper().showToast('تم إرسال الاقتراح بنجاح', Colors.black);

        Provider.of<SupportTicketService>(context, listen: false)
            .addNewDataToTicketList(
          title,
          jsonDecode(response.body)['ticket']['id'],
          'high',
          'open',
        );

        Navigator.pop(context);
      } else {
        print('خطأ في الإرسال: ${response.body}');
        OthersHelper().showToast('حدث خطأ أثناء الإرسال', Colors.red);
      }
    }
  }
}
