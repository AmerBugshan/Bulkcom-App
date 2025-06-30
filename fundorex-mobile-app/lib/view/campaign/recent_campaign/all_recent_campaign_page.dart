import 'package:flutter/material.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:fundorex/service/campaign_details_service.dart';
import 'package:fundorex/service/recent_campaing_service.dart';
import 'package:fundorex/view/campaign/campaign_details_page.dart';
import 'package:fundorex/view/campaign/components/campaign_card.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AllRecentCampaignPage extends StatelessWidget {
  const AllRecentCampaignPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RefreshController refreshController =
        RefreshController(initialRefresh: true);

    return Scaffold(
      appBar: CommonHelper().appbarCommon('Recent campaign', context, () {
        Navigator.pop(context);
      }, bgColor: Colors.white),
      backgroundColor: Colors.white,
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown: context.watch<RecentCampaignService>().currentPage > 1
            ? false
            : true,
        onRefresh: () async {
          final result =
              await Provider.of<RecentCampaignService>(context, listen: false)
                  .fetchAllRecentCampaign(context);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result =
              await Provider.of<RecentCampaignService>(context, listen: false)
                  .fetchAllRecentCampaign(context);
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
        child: SafeArea(
            child: SingleChildScrollView(
          child: Consumer<RecentCampaignService>(
            builder: (context, provider, child) => provider
                    .allRecentCampaign.isNotEmpty
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
                            height: 284,
                          ),
                          itemCount: provider.allRecentCampaign.length,
                          shrinkWrap: true,
                          clipBehavior: Clip.none,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return CampaignCard(
                                remainingTime: provider
                                    .allRecentCampaign[index].reamainingTime,
                                imageLink:
                                    provider.allRecentCampaign[index].image,
                                title: provider.allRecentCampaign[index].title,
                                width: 190,
                                marginRight: 0,
                                pressed: () {
                                  Provider.of<CampaignDetailsService>(context,
                                          listen: false)
                                      .fetchCampaignDetails(
                                          context: context,
                                          campaignId: provider
                                              .allRecentCampaign[index].id);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          CampaignDetailsPage(
                                        campaignId: provider
                                            .allRecentCampaign[index].id,
                                      ),
                                    ),
                                  );
                                },
                                camapaignId:
                                    provider.allRecentCampaign[index].id,
                                raisedAmount:
                                    provider.allRecentCampaign[index].raised,
                                goalAmount:
                                    provider.allRecentCampaign[index].amount);
                          },
                        ),
                        sizedBoxCustom(25),
                      ],
                    ))
                : Container(),
          ),
        )),
      ),
    );
  }
}
