import 'package:flutter/material.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:fundorex/service/campaign_details_service.dart';
import 'package:fundorex/service/followed_user_campaign_service.dart';
import 'package:fundorex/view/campaign/campaign_details_page.dart';
import 'package:fundorex/view/campaign/components/campaign_card.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FollowedUserAllCampaignPage extends StatelessWidget {
  const FollowedUserAllCampaignPage(
      {super.key,
      required this.followedUserId,
      required this.followedUserName});

  final followedUserId;
  final followedUserName;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    final RefreshController refreshController =
        RefreshController(initialRefresh: true);

    return Scaffold(
      appBar: CommonHelper().appbarCommon('Campaigns', context, () {
        Navigator.pop(context);
        Provider.of<FollowedUserCampaignService>(context, listen: false)
            .setDefault();
      }, bgColor: Colors.white),
      backgroundColor: Colors.white,
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown:
            context.watch<FollowedUserCampaignService>().currentPage > 1
                ? false
                : true,
        onRefresh: () async {
          final result = await Provider.of<FollowedUserCampaignService>(context,
                  listen: false)
              .fetchFollowedUserCampaign(context,
                  followedUserId: followedUserId);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result = await Provider.of<FollowedUserCampaignService>(context,
                  listen: false)
              .fetchFollowedUserCampaign(context,
                  followedUserId: followedUserId);
          if (result) {
            debugPrint('loadcomplete ran');
            //loadcomplete function loads the data again
            refreshController.loadComplete();
          } else {
            debugPrint('no more data');
            refreshController.loadNoData();

            Future.delayed(const Duration(seconds: 1), () {
              //it will reset footer no data state to idle and will let us load again
              refreshController.resetNoData();
            });
          }
        },
        child: WillPopScope(
          onWillPop: () {
            Provider.of<FollowedUserCampaignService>(context, listen: false)
                .setDefault();
            return Future.value(true);
          },
          child: SafeArea(
              child: SingleChildScrollView(
            child: Consumer<FollowedUserCampaignService>(
              builder: (context, provider, child) => provider.hasData == true
                  ? provider.followedUserCampaignList.isNotEmpty
                      ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenPadding,
                          ),
                          child: Column(
                            children: [
                              sizedBoxCustom(5),
                              GridView.builder(
                                gridDelegate: const FlutterzillaFixedGridView(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 15,
                                    crossAxisSpacing: 15,
                                    height: 286),
                                itemCount:
                                    provider.followedUserCampaignList.length,
                                shrinkWrap: true,
                                clipBehavior: Clip.none,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return CampaignCard(
                                      remainingTime: provider
                                          .followedUserCampaignList[index]
                                          .reamainingTime,
                                      imageLink: provider
                                          .followedUserCampaignList[index]
                                          .image,
                                      title: provider
                                          .followedUserCampaignList[index]
                                          .title,
                                      width: 190,
                                      marginRight: 0,
                                      pressed: () {
                                        Provider.of<CampaignDetailsService>(
                                                context,
                                                listen: false)
                                            .fetchCampaignDetails(
                                                context: context,
                                                campaignId: provider
                                                    .followedUserCampaignList[
                                                        index]
                                                    .id);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                CampaignDetailsPage(
                                              campaignId: provider
                                                  .followedUserCampaignList[
                                                      index]
                                                  .id,
                                            ),
                                          ),
                                        );
                                      },
                                      camapaignId: provider
                                          .followedUserCampaignList[index].id,
                                      raisedAmount: provider
                                          .followedUserCampaignList[index]
                                          .raised,
                                      goalAmount: provider
                                          .followedUserCampaignList[index]
                                          .amount);
                                },
                              ),
                              sizedBoxCustom(25),
                            ],
                          ))
                      : Container()
                  : OthersHelper().showError(context, 'No campaign found'),
            ),
          )),
        ),
      ),
    );
  }
}
