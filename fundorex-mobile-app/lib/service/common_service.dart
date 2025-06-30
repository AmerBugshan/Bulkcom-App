import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/category_service.dart';
import 'package:fundorex/service/create_campaign_service.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/featured_campaing_service.dart';
import 'package:fundorex/service/pay_services/payment_choose_service.dart';
import 'package:fundorex/service/profile_service.dart';
import 'package:fundorex/service/quick_donation_dropdown_service.dart';
import 'package:fundorex/service/recent_campaing_service.dart';
import 'package:fundorex/service/rtl_service.dart';
import 'package:fundorex/service/slider_service.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../view/home/landing_page.dart';
import '../view/utils/responsive.dart';

Future<bool> checkConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    OthersHelper()
        .showToast("Please turn on your internet connection", Colors.black);
    return false;
  } else {
    return true;
  }
}

removeUnderscore(String? value) {
  if (value?.isEmpty ?? true) {
    return "---";
  }
  return value!.replaceAll(RegExp('_'), ' ');
}

getDateOnly(date) {
  if (date == null) return ' ';
  return DateFormat('dd/MM/yyyy', "th").format(date);
}

runAtHomeScreen(BuildContext context) {
  Provider.of<SliderService>(context, listen: false).fetchSlider();
  Provider.of<QuickDonationDropdownService>(context, listen: false)
      .fetchCampaign(context);
  Provider.of<FeaturedCampaignService>(context, listen: false)
      .fetchFeaturedCampaign();
  Provider.of<CategoryService>(context, listen: false).fetchCategory();
  Provider.of<RecentCampaignService>(context, listen: false)
      .fetchRecentCampaign();
  Provider.of<ProfileService>(context, listen: false).getProfileDetails();
  Provider.of<CreateCampaignService>(context, listen: false)
      .checkCampaignCreatePermission(context);
}

runAtStart(BuildContext context) {
  Provider.of<RtlService>(context, listen: false).fetchCurrency();
  Provider.of<RtlService>(context, listen: false).fetchDirection();

  //fetch payment gateway list
  Provider.of<PaymentChooseService>(context, listen: false).fetchGatewayList();
  Provider.of<DonateService>(context, listen: false).fetchAmounts(context);
  //fetch translated strings
  Provider.of<AppStringService>(context, listen: false)
      .fetchTranslatedStrings()
      .then((_) {
    initLang(context);
  });
  Future.delayed(const Duration(microseconds: 500), () {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const LandingPage(),
      ),
    );
  });
}
