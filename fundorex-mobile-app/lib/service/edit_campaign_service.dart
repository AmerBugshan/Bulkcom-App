import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fundorex/service/create_campaign_service.dart';
import 'package:fundorex/service/my_campaign_list_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditCampaignService with ChangeNotifier {
  bool isLoading = false;

  setLoadingStatus(bool status) {
    isLoading = status;
    notifyListeners();
  }

  //FAQ
  List faqList = [];
  // =====================>
  //=====================>

  Future<bool> editCampaign(
    BuildContext context, {
    required String title,
    required String? causeContent,
    required String amount,
    required String deadLine,
    required existingImage,
    required campaignId,
  }) async {
    var pickedImage =
        Provider.of<CreateCampaignService>(context, listen: false).pickedImage;
    var selectedCategoryId =
        Provider.of<CreateCampaignService>(context, listen: false)
            .selectedCategoryId;

    faqList =
        Provider.of<CreateCampaignService>(context, listen: false).faqList;

    if (pickedImage == null && existingImage == null) {
      OthersHelper()
          .showSnackBar(context, 'You must select an image', Colors.red);
      return false;
    }

    if (selectedCategoryId == null) {
      OthersHelper()
          .showSnackBar(context, 'You must select a category', Colors.red);
      return false;
    }

    setLoadingStatus(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    //faq
    List faqTitleList = [];
    List faqDescList = [];

    for (int i = 0; i < faqList.length; i++) {
      faqTitleList.add(faqList[i]['title']);
      faqDescList.add(faqList[i]['desc']);
    }

    var faqTitleDescMap = {'title': faqTitleList, 'description': faqDescList};

    FormData formData;
    var dio = Dio();
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Authorization'] = "Bearer $token";

    if (pickedImage == null && faqList.isEmpty) {
      print('no new image no new faq');
      //if user did not select new image and did not add new faq

      formData = FormData.fromMap({
        'title': title,
        'cause_content': causeContent,
        'amount': amount,
        'categories_id': selectedCategoryId,
        'donation_id': campaignId,
        'deadline': deadLine,
      });
    } else if (pickedImage != null && faqList.isEmpty) {
      print('only new image no faq');
      //if user uploaded new image but no new faq
      formData = FormData.fromMap({
        'title': title,
        'cause_content': causeContent,
        'amount': amount,
        'categories_id': selectedCategoryId,
        'donation_id': campaignId,
        'deadline': deadLine,
        'image': await MultipartFile.fromFile(pickedImage.path,
            filename: 'campaing${pickedImage.path}.jpg'),
      });
    } else if (pickedImage == null && faqList.isNotEmpty) {
      print('only new faq');
      //if user added new faq but no new image
      formData = FormData.fromMap({
        'title': title,
        'cause_content': causeContent,
        'amount': amount,
        'categories_id': selectedCategoryId,
        'donation_id': campaignId,
        'deadline': deadLine,
        'faq': jsonEncode(faqTitleDescMap),
      });
    } else {
      print('new faq and image both');
      //if user added both new image and faq
      formData = FormData.fromMap({
        'title': title,
        'cause_content': causeContent,
        'amount': amount,
        'categories_id': selectedCategoryId,
        'donation_id': campaignId,
        'deadline': deadLine,
        'faq': jsonEncode(faqTitleDescMap),
        'image': await MultipartFile.fromFile(pickedImage.path,
            filename: 'campaing${pickedImage.path}.jpg'),
      });
    }

    var response = await dio.post(
      '$baseApi/user/user-campaign/update/$campaignId',
      data: formData,
    );

    setLoadingStatus(false);

    final jsonData = response.data;

    if (((response.statusCode ?? 0) >= 200 &&
            (response.statusCode ?? 0) < 300) &&
        jsonData['type'] == 'success') {
      OthersHelper().showToast('Campaign updated successfully', Colors.black);
      Navigator.pop(context);

      Provider.of<MyCampaignListService>(context, listen: false)
          .fetchMyCampaigns(context);

      Provider.of<CreateCampaignService>(context, listen: false)
          .makePickedImageAndFaqNull();
      return true;
    } else {
      print(response.data);
      OthersHelper().showToast('Something went wrong', Colors.black);
      return false;
    }
  }
}
