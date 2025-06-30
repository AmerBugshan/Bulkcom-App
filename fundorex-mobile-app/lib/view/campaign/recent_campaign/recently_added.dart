import 'package:flutter/material.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/recent_campaing_service.dart';
import 'package:fundorex/view/campaign/campaign_details_page.dart';
import 'package:fundorex/view/campaign/components/campaign_card.dart';
import 'package:fundorex/view/campaign/recent_campaign/all_recent_campaign_page.dart';
import 'package:fundorex/view/home/components/section_title.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

import '../../../service/campaign_details_service.dart';

class RecentlyAdded extends StatelessWidget {
  const RecentlyAdded({
    super.key,
    required this.cc,
  });
  final ConstantColors cc;

  @override
  Widget build(BuildContext context) {
    return Consumer<RecentCampaignService>(
      builder: (context, provider, child) => provider.hasError != true
          ? provider.recentCampaignList.isNotEmpty
              ? Consumer<AppStringService>(
                  builder: (context, ln, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionTitle(
                        cc: cc,
                        title: ln.getString('Recent campaigns'),
                        pressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const AllRecentCampaignPage(),
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
                                i < provider.recentCampaignList.length;
                                i++)
                              CampaignCard(
                                  remainingTime: provider
                                      .recentCampaignList[i].reamainingTime,
                                  imageLink:
                                      provider.recentCampaignList[i].image ??
                                          placeHolderUrl,
                                  title: provider.recentCampaignList[i].title,
                                  width: 190,
                                  marginRight: 20,
                                  pressed: () {
                                    Provider.of<CampaignDetailsService>(context,
                                            listen: false)
                                        .fetchCampaignDetails(
                                            context: context,
                                            campaignId: provider
                                                .recentCampaignList[i].id);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            CampaignDetailsPage(
                                          campaignId:
                                              provider.recentCampaignList[i].id,
                                        ),
                                      ),
                                    );
                                  },
                                  camapaignId:
                                      provider.recentCampaignList[i].id,
                                  raisedAmount:
                                      provider.recentCampaignList[i].raised,
                                  goalAmount:
                                      provider.recentCampaignList[i].amount)
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container()
          : Container(),
    );
  }
}
