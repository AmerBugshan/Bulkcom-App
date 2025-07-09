import 'package:flutter/material.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/bottom_nav_service.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/service/profile_service.dart';
import 'package:fundorex/view/campaign/featured_campaign/featured_campaign.dart';
import 'package:fundorex/view/campaign/recent_campaign/recently_added.dart';
import 'package:fundorex/view/home/components/categories.dart';
import 'package:fundorex/view/home/components/quick_donations.dart';
import 'package:fundorex/view/home/components/slider_home.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    runAtHomeScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<AppStringService>(
          builder: (context, ln, child) => Column(children: [
            sizedBoxCustom(10),
            //name and profile image

            Consumer<ProfileService>(
              builder: (context, profileProvider, child) => profileProvider
                          .profileDetails !=
                      null
                  ? profileProvider.profileDetails != 'error'
                      ? InkWell(
                          onTap: () {
                            Provider.of<BottomNavService>(context,
                                    listen: false)
                                .setCurrentIndex(3);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              children: [
                                //name
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ln.getString('مرحبا!') + ',',
                                      style: TextStyle(
                                        color: cc.greyParagraph,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      profileProvider.profileDetails.name,
                                      style: TextStyle(
                                        color: cc.greyFour,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )),

                                //profile image
                                profileProvider.profileDetails.image != null
                                    ? CommonHelper().profileImage(
                                        profileProvider.profileDetails.image,
                                        48,
                                        48)
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          'assets/images/avatar.png',
                                          height: 48,
                                          width: 48,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        )
                      : Text(ln.getString('Could not load user profile info'))
                  : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonHelper().titleCommon("مرحبا! 👋"),
                          CommonHelper().titleCommon("أهلا بك الى بلكوم"),
                        ],
                      ),
                    ),
            ),

            const SizedBox(
              height: 10,
            ),
            CommonHelper().dividerCommon(),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    //Slider ========>
                    // const SliderHome(),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: screenPadding),
                      margin: const EdgeInsets.only(top: 25),
                      child: Column(children: [

                        Categories(cc: cc, width: 160, marginRight: 20),

                        sizedBoxCustom(24),

                        //featured campaign ======>
                        FeaturedCampaign(cc: cc),

                        sizedBoxCustom(24),



                        //Quick donations dropdown =========>
                        QuickDonations(
                          amountController: amountController,
                        ),

                        sizedBoxCustom(25),

                        RecentlyAdded(cc: cc),
                        sizedBoxCustom(28),
                      ]),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
