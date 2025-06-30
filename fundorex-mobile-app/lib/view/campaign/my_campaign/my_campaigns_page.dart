import 'package:flutter/material.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/my_campaign_list_service.dart';
import 'package:fundorex/view/campaign/components/my_campaign_card.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:fundorex/view/utils/responsive.dart';
import 'package:provider/provider.dart';

class MyCampaignsPage extends StatelessWidget {
  const MyCampaignsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<MyCampaignListService>(context, listen: false)
        .fetchMyCampaigns(context);

    ConstantColors cc = ConstantColors();

    return Scaffold(
      appBar: CommonHelper().appbarCommon('My campaigns', context, () {
        Navigator.pop(context);
      }, bgColor: Colors.white),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Consumer<AppStringService>(
          builder: (context, ln, child) => Consumer<MyCampaignListService>(
            builder: (context, provider, child) => provider.isLoading == false
                ? provider.myCampaignList.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: Column(
                          children: [
                            sizedBoxCustom(5),
                            GridView.builder(
                              gridDelegate: const FlutterzillaFixedGridView(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 15,
                                  height: 304),
                              itemCount: provider.myCampaignList.length,
                              shrinkWrap: true,
                              clipBehavior: Clip.none,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return MyCampaignCard(
                                  imageLink:
                                      provider.myCampaignList[index].image,
                                  title: provider.myCampaignList[index].title,
                                  desc: provider
                                      .myCampaignList[index].causeContent,
                                  categoryId: provider
                                      .myCampaignList[index].categoriesId,
                                  endDate:
                                      provider.myCampaignList[index].deadline,
                                  faq: provider.myCampaignList[index].faq,
                                  width: 190,
                                  marginRight: 0,
                                  pressed: () {
                                    // Provider.of<CampaignDetailsService>(context,
                                    //         listen: false)
                                    //     .fetchCampaignDetails(
                                    //         context: context,
                                    //         campaignId: provider
                                    //             .myCampaignList[index].id);
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute<void>(
                                    //     builder: (BuildContext context) =>
                                    //         CampaignDetailsPage(
                                    //       campaignId:
                                    //           provider.myCampaignList[index].id,
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  campaignId: provider.myCampaignList[index].id,
                                  raisedAmount:
                                      provider.myCampaignList[index].raised,
                                  goalAmount:
                                      provider.myCampaignList[index].amount,

                                  // buttonColor: Colors.black,
                                );
                              },
                            ),
                            sizedBoxCustom(25),
                          ],
                        ))
                    : Container(
                        height: screenHeight - 120,
                        alignment: Alignment.center,
                        child:
                            Text(ln.getString('You do not have any campaign')),
                      )
                : Container(
                    height: screenHeight - 120,
                    alignment: Alignment.center,
                    child: OthersHelper().showLoading(cc.primaryColor),
                  ),
          ),
        ),
      )),
    );
  }
}
