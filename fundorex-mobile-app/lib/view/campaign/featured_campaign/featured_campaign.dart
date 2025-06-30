import 'package:flutter/material.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/campaign_details_service.dart';
import 'package:fundorex/service/featured_campaing_service.dart';
import 'package:fundorex/view/campaign/campaign_details_page.dart';
import 'package:fundorex/view/campaign/components/campaign_card.dart';
import 'package:fundorex/view/campaign/featured_campaign/all_featured_campaign_page.dart';
import 'package:fundorex/view/home/components/section_title.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

class FeaturedCampaign extends StatelessWidget {
  const FeaturedCampaign({
    super.key,
    required this.cc,
  });
  final ConstantColors cc;

  @override
  Widget build(BuildContext context) {
    return Consumer<FeaturedCampaignService>(
      builder: (context, provider, child) => provider.hasError != true
          ? provider.featuredList.isNotEmpty
              ? Consumer<AppStringService>(
                  builder: (context, ln, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionTitle(
                        cc: cc,
                        title: ln.getString('Featured campaigns'),
                        pressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const AllFeaturedCampaignPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        height: 284,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          clipBehavior: Clip.none,
                          children: [
                            for (int i = 0;
                                i < provider.featuredList.length;
                                i++)
                              CampaignCard(
                                  remainingTime:
                                      provider.featuredList[i].reamainingTime,
                                  imageLink: provider.featuredList[i].image ??
                                      placeHolderUrl,
                                  title: provider.featuredList[i].title,
                                  width: 190,
                                  marginRight: 20,
                                  pressed: () {
                                    Provider.of<CampaignDetailsService>(context,
                                            listen: false)
                                        .fetchCampaignDetails(
                                            context: context,
                                            campaignId:
                                                provider.featuredList[i].id);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            CampaignDetailsPage(
                                          campaignId:
                                              provider.featuredList[i].id,
                                        ),
                                      ),
                                    );
                                  },
                                  camapaignId: provider.featuredList[i].id,
                                  raisedAmount: provider.featuredList[i].raised,
                                  goalAmount: provider.featuredList[i].amount)
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : OthersHelper().showLoading(cc.primaryColor)
          : Container(),
    );
  }
}
