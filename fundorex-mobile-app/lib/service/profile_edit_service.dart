import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fundorex/helper/extension/string_extension.dart';
import 'package:fundorex/service/country_states_service.dart';
import 'package:fundorex/service/profile_service.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileEditService with ChangeNotifier {
  bool isloading = false;

  String countryCode = 'BD';

  setCountryCode(code) {
    countryCode = code;
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

  final ImagePicker _picker = ImagePicker();
  Future pickImage() async {
    final XFile? imageFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      return imageFile;
    } else {
      return null;
    }
  }

  updateProfile(
      {required name,
      required email,
      required phone,
      required state,
      required city,
      required zipcode,
      required address,
      String? imagePath,
      required context}) async {
    setLoadingTrue();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (baseApi.contains("fundorex.xgenious")) {
      await Future.delayed(const Duration(seconds: 1));
      "This function is turned off for demo app".showToast();
      setLoadingFalse();
      return false;
    }
    var dio = Dio();
    // dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers["Authorization"] = "Bearer $token";

    var countryId = Provider.of<CountryStatesService>(context, listen: false)
        .selectedCountryId;

    FormData formData;
    if (imagePath != null) {
      formData = FormData.fromMap({
        'name': name,
        'email': email,
        'phone': phone,
        'image': await MultipartFile.fromFile(imagePath,
            filename: 'profileImage$name$address$imagePath.jpg'),
        'state': state,
        'city': city,
        'zipcode': zipcode,
        'country_id': countryId,
        'address': address,
      });
    } else {
      formData = FormData.fromMap({
        'name': name,
        'email': email,
        'phone': phone,
        'state': state,
        'city': city,
        'zipcode': zipcode,
        'country_id': countryId,
        'address': address,
      });
    }
    var response = await dio.post(
      '$baseApi/user/update-profile',
      data: formData,
    );

    if ((response.statusCode ?? 0) >= 200 && (response.statusCode ?? 0) < 300) {
      setLoadingFalse();
      OthersHelper().showToast('تم تحديث الملف الشخصي بنجاح.', Colors.black);

      await Provider.of<ProfileService>(context, listen: false)
          .getProfileDetails(isFromProfileupdatePage: true);
      return true;
    } else {
      setLoadingFalse();
      print(response.data);
      OthersHelper().showToast('حدث خطأ', Colors.black);
      return false;
    }
  }

  // Future submitSubscription(name, email, phone, cityId, areaId, countryId,
  //     postCode, address, about, context, File file, String filename) async {
  //   setLoadingTrue();

  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var token = prefs.getString('token');

  //   ///MultiPart request
  //   var request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse(
  //         "https://nazmul.xgenious.com/qixer_with_api/api/v1/user/update-profile"),
  //   );
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //     "Authorization": "Bearer $token",
  //     // "Content-type": "multipart/form-data"
  //   };
  //   request.files.add(
  //     http.MultipartFile(
  //       'file',
  //       file.readAsBytes().asStream(),
  //       file.lengthSync(),
  //       filename: filename,
  //       // contentType: MediaType('image','jpeg'),
  //     ),
  //   );
  //   request.headers.addAll(headers);
  //   request.fields.addAll({
  //     'name': 'ccc',
  //     'email': 'c@c',
  //     'phone': '554',
  //     'service_city': '2',
  //     'service_area': '2',
  //     'country_id': '2',
  //     'post_code': '222',
  //     'address': 'asdfa',
  //     'about': 'asdsfd'
  //   });
  //   print("request: " + request.toString());
  //   var res = await request.send();
  //   print("This is response:" + res.toString());
  //   print(res.statusCode);
  //   setLoadingFalse();
  //   if (res.statusCode == 201) {
  //     Navigator.pop(context);
  //     Provider.of<ProfileService>(context, listen: false).getProfileDetails();
  //   } else {
  //     OthersHelper().showToast(
  //         'Something went wrong. status code ${res.statusCode}', Colors.black);
  //   }
  //   return true;
  // }
}
