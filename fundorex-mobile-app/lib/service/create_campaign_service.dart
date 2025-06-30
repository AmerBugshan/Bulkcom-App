// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fundorex/model/category_model.dart';
import 'package:fundorex/view/campaign/my_campaign/my_campaigns_page.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateCampaignService with ChangeNotifier {
  bool isLoading = false;
  bool dropdownLoading = false;
  bool hasCampaignCreatePermission = true;
  bool campaignPermissionLoaded = false;

  setLoadingStatus(bool status) {
    isLoading = status;
    notifyListeners();
  }

  setDropdownLoadingStatus(bool status) {
    dropdownLoading = status;
    notifyListeners();
  }

  setCampaignCreatePermissionDefault() {
    hasCampaignCreatePermission = true;
    campaignPermissionLoaded = false;
    notifyListeners();
  }

  var categoryDropdownList = [];
  var categoryDropdownIndexList = [];
  var selectedCategory;
  var selectedCategoryId;

  setCategoryValue(value) {
    selectedCategory = value;
    notifyListeners();
  }

  setSelectedCategoryId(value) {
    selectedCategoryId = value;
    notifyListeners();
  }

  setCategoryDropdownDefault() {
    categoryDropdownList = [];
    categoryDropdownIndexList = [];
    selectedCategory = null;
    selectedCategoryId = null;
  }

//Image pick
//=============>
  var pickedImage;
  // List<XFile>? imageGallery = [];
  // List<XFile>? medicalDocuments = [];

  final ImagePicker _picker = ImagePicker();

  Future pickImage(BuildContext context) async {
    pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    notifyListeners();
  }

  //make pickedImage null
  makePickedImageAndFaqNull() {
    pickedImage = null;
    faqList = [];
    notifyListeners();
  }

//gallery image pick
//============>
  // Future pickImageGallery(BuildContext context) async {
  //   imageGallery = await _picker.pickMultiImage();

  //   notifyListeners();
  // }

  //gallery image pick
//============>
  // Future pickMedicalDocuments(BuildContext context) async {
  //   medicalDocuments = await _picker.pickMultiImage();

  //   notifyListeners();
  // }

  //FAQ
  List faqList = [];

  addFaq(String title, String desc) {
    faqList.add({'title': title, 'desc': desc});
    notifyListeners();
  }

  removeFaq(int index) {
    faqList.removeAt(index);
    notifyListeners();
  }

  // =====================>
  //=====================>

  Future<bool> createCampaign(
    BuildContext context, {
    required String title,
    required String? causeContent,
    required String amount,
    required String deadLine,
  }) async {
    if (pickedImage == null) {
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

    var formData;
    var dio = Dio();
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Authorization'] = "Bearer $token";

    formData = FormData.fromMap({
      'title': title,
      'cause_content': causeContent,
      'amount': amount,
      'categories_id': selectedCategoryId,
      'deadline': deadLine,
      'faq': jsonEncode(faqTitleDescMap),
      'image': await MultipartFile.fromFile(pickedImage.path,
          filename: 'campaing${pickedImage.path}.jpg'),
    });

    var response = await dio.post(
      '$baseApi/user/user-campaign/store',
      data: formData,
    );

    setLoadingStatus(false);
    print(response.data);
    final jsonData = response.data;

    if (((response.statusCode ?? 0) >= 200 &&
            (response.statusCode ?? 0) < 300) &&
        jsonData['type'] == 'success') {
      OthersHelper().showToast('Campaign created successfully', Colors.black);
      Navigator.pop(context);

      makePickedImageAndFaqNull();

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const MyCampaignsPage()));

      return true;
    } else {
      print(response.data);
      OthersHelper().showToast('Something went wrong', Colors.black);
      return false;
    }
  }

  //==================>
  //==============>
  fetchCampaignCategory(BuildContext context, {categoryId}) async {
    Future.delayed(const Duration(milliseconds: 500), () {
      setDropdownLoadingStatus(true);
    });

    setCategoryDropdownDefault();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    var response = await http.get(Uri.parse('$baseApi/donation?type=category'),
        headers: header);

    setDropdownLoadingStatus(false);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var data = CategoryModel.fromJson(jsonDecode(response.body));
      for (int i = 0; i < data.donationCategory.data.data.length; i++) {
        categoryDropdownList.add(data.donationCategory.data.data[i].title);
        categoryDropdownIndexList.add(data.donationCategory.data.data[i].id);
      }

      if (categoryId == null) {
        //if no categoryId id passed then show first one as selected
        selectedCategory = data.donationCategory.data.data[0].title;
        selectedCategoryId = data.donationCategory.data.data[0].id;
      } else {
        //select initial one based on category id of campaign
        for (int i = 0; i < data.donationCategory.data.data.length; i++) {
          if (data.donationCategory.data.data[i].id == categoryId) {
            selectedCategory = data.donationCategory.data.data[i].title;
            selectedCategoryId = data.donationCategory.data.data[i].id;
            break;
          }
        }
      }

      notifyListeners();
      // fetchStates(selectedCountryId, context);
    } else {
      print(response.body);
      //error fetching data
      categoryDropdownList.add('Select Category');
      categoryDropdownIndexList.add(null);
      selectedCategory = 'Select Category';
      selectedCategoryId = null;
      // fetchStates(selectedCountryId, context);
      notifyListeners();
    }
  }

  //check campaign create permission
  //======================>

  checkCampaignCreatePermission(BuildContext context) async {
    // var connection = await checkConnection();
    // if (!connection) return;

    // if (campaignPermissionLoaded == true) return;

    // print('ran campaign permission function');

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var token = prefs.getString('token');
    // var header = {
    //   //if header type is application/json then the data should be in jsonEncode method
    //   "Accept": "application/json",
    //   // "Content-Type": "application/json"
    //   "Authorization": "Bearer $token",
    // };

    // var response = await http.get(
    //     Uri.parse("$baseApi/user/user-campaign/campaign-permission"),
    //     headers: header);

    // if (response.statusCode >= 200 && response.statusCode < 300) {
    //   campaignPermissionLoaded = true;

    //   final jsonData = jsonDecode(response.body);
    //   if (jsonData['user_campaign_permission'] == 'off') {
    //     hasCampaignCreatePermission = false;
    //   } else {
    //     hasCampaignCreatePermission = true;
    //   }
    //   notifyListeners();
    // } else {
    //   print(response.body);
    // }
  }
}
