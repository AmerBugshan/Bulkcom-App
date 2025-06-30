import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/model/category_model.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CategoryService with ChangeNotifier {
  List categoryList = [];
  bool hasError = false;

  fetchCategory() async {
    if (categoryList.isNotEmpty) return;

    //==============>

    var connection = await checkConnection();
    if (connection) {
      //if connection is ok
      var response =
          await http.get(Uri.parse('$baseApi/donation?type=category'));

      print(response.body);
      print(response.statusCode);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        hasError = false;
        var data = CategoryModel.fromJson(jsonDecode(response.body));
        categoryList = data.donationCategory.data.data;
        notifyListeners();
      } else {
        //Something went wrong
        hasError = true;
        notifyListeners();
      }
    }
  }

  //All  feature campaign service
  var allCategories = [];

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

  fetchAllCategories(context, {bool isrefresh = false}) async {
    if (isrefresh) {
      //making the list empty first to show loading bar (we are showing loading bar while the product list is empty)
      //we are make the list empty when the sub category or brand is selected because then the refresh is true
      allCategories = [];
      notifyListeners();

      Provider.of<CategoryService>(context, listen: false)
          .setCurrentPage(currentPage);
    } else {}

    var connection = await checkConnection();
    if (!connection) return;
    //if connection is ok

    try {
      var response = await http
          .get(Uri.parse("$baseApi/donation?type=category&page=$currentPage"));

      if ((response.statusCode >= 200 && response.statusCode < 300) &&
          jsonDecode(response.body)['donation_category']['data'].isNotEmpty) {
        var data = CategoryModel.fromJson(jsonDecode(response.body));

        setTotalPage(data.donationCategory.lastPage);

        if (isrefresh) {
          print('refresh true');
          //if refreshed, then remove all service from list and insert new data
          allCategories = [];
          allCategories = data.donationCategory.data.data;
          notifyListeners();
        } else {
          print('add new data');

          //else add more data to list
          for (int i = 0; i < data.donationCategory.data.data.length; i++) {
            allCategories.add(data.donationCategory.data.data[i]);
          }
          notifyListeners();
        }

        currentPage++;
        setCurrentPage(currentPage);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
