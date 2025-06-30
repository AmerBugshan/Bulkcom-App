import 'package:flutter/material.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/followed_user_list_service.dart';
import 'package:fundorex/view/campaign/followed_user_all_campaign_page.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:fundorex/view/utils/responsive.dart';
import 'package:provider/provider.dart';

class FollowedUserListPage extends StatelessWidget {
  const FollowedUserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<FollowedUserListService>(context, listen: false)
        .fetchFollowedUser();
    final lnProvider = Provider.of<AppStringService>(context, listen: false);

    ConstantColors cc = ConstantColors();
    return Scaffold(
      appBar:
          CommonHelper().appbarCommon('Following user campaigns', context, () {
        Navigator.pop(context);
      }, bgColor: Colors.white),
      backgroundColor: cc.bgGrey,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Consumer<FollowedUserListService>(
          builder: (context, provider, child) => provider.hasError == false
              ? provider.isloading == false
                  ? Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenPadding, vertical: 25),
                      child: Column(children: [
                        for (int i = 0;
                            i < provider.followedUserList.length;
                            i++)
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      FollowedUserAllCampaignPage(
                                    followedUserId: provider
                                        .followedUserList[i].campaignOwnerId,
                                    followedUserName: provider
                                        .followedUserList[i].campaignOwnerName,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 20),
                                margin: const EdgeInsets.only(bottom: 17),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        provider.followedUserList[i]
                                            .campaignOwnerName,
                                        style: TextStyle(
                                            color: cc.greyFour,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Expanded(
                                        child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${provider.followedUserList[i].campaignOwnerCampaignItem} ${lnProvider.getString("Campaigns")}',
                                          style: TextStyle(
                                              color: cc.greyFour,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_right_outlined,
                                          color: cc.greyFour,
                                        )
                                      ],
                                    ))
                                  ],
                                )),
                          ),
                      ]),
                    )
                  : SizedBox(
                      height: screenHeight - 180,
                      child: OthersHelper().showLoading(cc.primaryColor),
                    )
              : OthersHelper().showError(context, "No user followed"),
        ),
      )),
    );
  }
}
