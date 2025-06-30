import 'package:flutter/material.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:fundorex/service/campaign_details_service.dart';
import 'package:fundorex/service/featured_campaing_service.dart';
import 'package:fundorex/view/campaign/campaign_details_page.dart';
import 'package:fundorex/view/campaign/components/campaign_card.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AllFeaturedCampaignPage extends StatelessWidget {
  const AllFeaturedCampaignPage({super.key});

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    final RefreshController refreshController =
        RefreshController(initialRefresh: true);

    return Scaffold(
      appBar: CommonHelper().appbarCommon('Featured campaign', context, () {
        Navigator.pop(context);
      }, bgColor: Colors.white),
      backgroundColor: Colors.white,
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown: context.watch<FeaturedCampaignService>().currentPage > 1
            ? false
            : true,
        onRefresh: () async {
          final result =
              await Provider.of<FeaturedCampaignService>(context, listen: false)
                  .fetchAllFeaturedCampaign(context);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result =
              await Provider.of<FeaturedCampaignService>(context, listen: false)
                  .fetchAllFeaturedCampaign(context);
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
          child: Consumer<FeaturedCampaignService>(
            builder: (context, provider, child) => provider
                    .allFeaturedCampaign.isNotEmpty
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
                            height: 286,
                          ),
                          itemCount: provider.allFeaturedCampaign.length,
                          shrinkWrap: true,
                          clipBehavior: Clip.none,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return CampaignCard(
                                remainingTime: provider
                                    .allFeaturedCampaign[index].reamainingTime,
                                imageLink:
                                    provider.allFeaturedCampaign[index].image,
                                title:
                                    provider.allFeaturedCampaign[index].title,
                                width: 190,
                                marginRight: 0,
                                pressed: () {
                                  Provider.of<CampaignDetailsService>(context,
                                          listen: false)
                                      .fetchCampaignDetails(
                                          context: context,
                                          campaignId:
                                              provider.featuredList[index].id);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          CampaignDetailsPage(
                                        campaignId:
                                            provider.featuredList[index].id,
                                      ),
                                    ),
                                  );
                                },
                                camapaignId: provider.featuredList[index].id,
                                raisedAmount:
                                    provider.allFeaturedCampaign[index].raised,
                                goalAmount:
                                    provider.allFeaturedCampaign[index].amount);
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
