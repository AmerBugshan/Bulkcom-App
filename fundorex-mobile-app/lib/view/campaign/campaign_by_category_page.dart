import 'package:flutter/material.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/campaign_by_category_service.dart';
import 'package:fundorex/service/campaign_details_service.dart';
import 'package:fundorex/view/campaign/campaign_details_page.dart';
import 'package:fundorex/view/campaign/components/campaign_card.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/responsive.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CampaignByCategoryPage extends StatelessWidget {
  const CampaignByCategoryPage(
      {super.key, required this.categoryId, required this.categoryName});

  final categoryId;
  final categoryName;

  @override
  Widget build(BuildContext context) {
    final RefreshController refreshController =
        RefreshController(initialRefresh: true);

    ConstantColors cc = ConstantColors();

    return Scaffold(
      appBar: CommonHelper().appbarCommon(categoryName, context, () {
        Provider.of<CampaignByCategoryService>(context, listen: false)
            .setDefault();

        Navigator.pop(context);
      }, bgColor: Colors.white),
      backgroundColor: Colors.white,
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown:
            context.watch<CampaignByCategoryService>().currentPage > 1
                ? false
                : true,
        onRefresh: () async {
          final result = await Provider.of<CampaignByCategoryService>(context,
                  listen: false)
              .fetchCampaignByCategory(context, categoryId);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result = await Provider.of<CampaignByCategoryService>(context,
                  listen: false)
              .fetchCampaignByCategory(context, categoryId);
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
            Provider.of<CampaignByCategoryService>(context, listen: false)
                .setDefault();
            return Future.value(true);
          },
          child: SafeArea(
              child: SingleChildScrollView(
            child: Consumer<AppStringService>(
              builder: (context, ln, child) => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenPadding,
                  ),
                  child: Consumer<CampaignByCategoryService>(
                    builder: (context, provider, child) => provider.hasData ==
                            true
                        ? provider.campaignByCategoryList.isNotEmpty
                            ? Column(
                                children: [
                                  sizedBoxCustom(5),
                                  GridView.builder(
                                    gridDelegate:
                                        const FlutterzillaFixedGridView(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 15,
                                            crossAxisSpacing: 15,
                                            height: 284),
                                    itemCount:
                                        provider.campaignByCategoryList.length,
                                    shrinkWrap: true,
                                    clipBehavior: Clip.none,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return CampaignCard(
                                          remainingTime: provider
                                              .campaignByCategoryList[index]
                                              .remainingTime,
                                          imageLink: provider
                                                  .campaignByCategoryList[index]
                                                  .image ??
                                              placeHolderUrl,
                                          title: provider
                                              .campaignByCategoryList[index]
                                              .title,
                                          width: double.infinity,
                                          marginRight: 0,
                                          pressed: () {
                                            Provider.of<CampaignDetailsService>(
                                                    context,
                                                    listen: false)
                                                .fetchCampaignDetails(
                                                    context: context,
                                                    campaignId: provider
                                                        .campaignByCategoryList[
                                                            index]
                                                        .id);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) =>
                                                        CampaignDetailsPage(
                                                  campaignId: provider
                                                      .campaignByCategoryList[
                                                          index]
                                                      .id,
                                                ),
                                              ),
                                            );
                                          },
                                          camapaignId: provider
                                              .campaignByCategoryList[index].id,
                                          raisedAmount: provider
                                              .campaignByCategoryList[index]
                                              .raised,
                                          goalAmount: provider
                                              .campaignByCategoryList[index]
                                              .amount);
                                    },
                                  ),
                                  sizedBoxCustom(25),
                                ],
                              )
                            : Container()
                        : Container(
                            height: screenHeight - 140,
                            alignment: Alignment.center,
                            child: Text(ln.getString('No campaign found'))),
                  )),
            ),
          )),
        ),
      ),
    );
  }
}
