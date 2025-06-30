import 'package:flutter/material.dart';
import 'package:fundorex/helper/extension/context_extension.dart';
import 'package:fundorex/service/account_delete_service.dart';
import 'package:fundorex/service/profile_service.dart';
import 'package:fundorex/view/account_delete/account_delete_view.dart';
import 'package:fundorex/view/payment/const_styles.dart';
import 'package:fundorex/view/profile/change_password_page.dart';
import 'package:fundorex/view/profile/components/profile_helper.dart';
import 'package:fundorex/view/profile/components/single_menu_item.dart';
import 'package:fundorex/view/profile/login_or_register.dart';
import 'package:fundorex/view/profile/profile_edit.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

import '../auth/login/login.dart';
import '../utils/alerts.dart';
import '../utils/custom_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cc = ConstantColors();

    return Scaffold(
        backgroundColor: cc.bgGrey,
        appBar: CommonHelper().appbarCommon('Profile', context, () {},
            hasBackBtn: false, bgColor: Colors.white),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: physicsCommon,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: screenPadding),
              child: Consumer<ProfileService>(
                builder: (context, profileProvider, child) => profileProvider
                            .profileDetails !=
                        null
                    ? profileProvider.profileDetails != 'error'
                        ? Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 20),
                                margin:
                                    const EdgeInsets.only(bottom: 17, top: 23),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenPadding),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //profile image, name ,desc
                                            Container(
                                              alignment: Alignment.center,
                                              width: double.infinity,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  //Profile image section =======>
                                                  InkWell(
                                                    highlightColor:
                                                        Colors.transparent,
                                                    splashColor:
                                                        Colors.transparent,
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute<void>(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              const ProfileEditPage(),
                                                        ),
                                                      );
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        profileProvider
                                                                    .profileDetails
                                                                    .image !=
                                                                null
                                                            ? CommonHelper()
                                                                .profileImage(
                                                                    profileProvider
                                                                        .profileDetails
                                                                        .image,
                                                                    62,
                                                                    62)
                                                            : ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/avatar.png',
                                                                  height: 62,
                                                                  width: 62,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),

                                                        const SizedBox(
                                                          height: 12,
                                                        ),

                                                        //user name
                                                        CommonHelper().titleCommon(
                                                            profileProvider
                                                                    .profileDetails
                                                                    .name ??
                                                                ''),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        //phone
                                                        CommonHelper()
                                                            .paragraphCommon(
                                                                profileProvider
                                                                        .profileDetails
                                                                        .phone ??
                                                                    '',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                      ],
                                                    ),
                                                  ),

                                                  //Grid cards
                                                ],
                                              ),
                                            ),

                                            //
                                          ]),
                                    ),

                                    // Personal information ==========>
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 25,
                                            ),
                                            ConstStyles().commonRow(
                                                'Email',
                                                profileProvider
                                                        .profileDetails.email ??
                                                    '-'),
                                            ConstStyles().commonRow(
                                                'City',
                                                profileProvider
                                                        .profileDetails.city ??
                                                    '-'),
                                            ConstStyles().commonRow(
                                                'State',
                                                profileProvider
                                                        .profileDetails.state ??
                                                    '-'),
                                            ConstStyles().commonRow(
                                                'Zip Code',
                                                profileProvider.profileDetails
                                                        .zipcode ??
                                                    '-'),
                                            ConstStyles().commonRow(
                                                'Country',
                                                profileProvider.profileDetails
                                                        .country?.name ??
                                                    '-'),
                                            ConstStyles().commonRow(
                                                'Address',
                                                profileProvider.profileDetails
                                                        .address ??
                                                    '-',
                                                lastBorder: true),
                                          ]),
                                    ),

                                    const SizedBox(
                                      height: 30,
                                    ),

                                    CommonHelper().buttonPrimary('Edit Profile',
                                        () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              const ProfileEditPage(),
                                        ),
                                      );
                                    }, paddingVertical: 15)
                                  ],
                                ),
                              ),

                              //Change password,

                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const ChangePasswordPage(),
                                    ),
                                  );
                                },
                                child: SingleMenuItem(
                                  cc: cc,
                                  iconSvg: 'assets/svg/password.svg',
                                  title: 'Change Password',
                                ),
                              ),

                              // logout
                              sizedBoxCustom(15),
                              InkWell(
                                onTap: () {
                                  Alerts().confirmationAlert(
                                    context: context,
                                    title: "Are you sure",
                                    onConfirm: () async {
                                      Provider.of<AccountDeleteService>(context,
                                              listen: false)
                                          .tryAccountDelete(context)
                                          .then((value) {});
                                      await Future.delayed(
                                          const Duration(seconds: 1));
                                    },
                                    buttonText: "Delete",
                                    buttonColor: cc.warningColor,
                                  );
                                  // context.toNamed(AccountDeleteView.routeName);
                                },
                                child: SingleMenuItem(
                                  cc: cc,
                                  iconSvg: 'assets/svg/trash.svg',
                                  title: 'Delete Account',
                                ),
                              ),
                              sizedBoxCustom(15),
                              InkWell(
                                onTap: () {
                                  ProfileHelper().logoutPopup(context);
                                },
                                child: SingleMenuItem(
                                  cc: cc,
                                  iconSvg: 'assets/svg/exit.svg',
                                  title: 'Log Out',
                                ),
                              ),

                              sizedBoxCustom(25),
                            ],
                          )
                        : OthersHelper()
                            .showError(context, 'Something went wrong')
                    : const LoginOrRegister(),
              ),
            ),
          ),
        ));
  }
}
