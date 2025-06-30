import 'package:flutter/material.dart';
import 'package:fundorex/service/campaign_details_service.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:provider/provider.dart';

class UpdatesTab extends StatelessWidget {
  const UpdatesTab({super.key});

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return Consumer<CampaignDetailsService>(
      builder: (context, provider, child) => Container(
          padding: const EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
              border: Border(
            top: BorderSide(
              color: Colors.grey.withOpacity(.3),
              width: 1.0,
            ),
          )),
          child: Column(
            children: [
              for (int i = 0; i < provider.campaignDetails.updates.length; i++)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonHelper().profileImage(
                          provider.campaignDetails.updates[i].image ??
                              placeHolderUrl,
                          55,
                          55,
                          radius: 10),

                      //title and desc
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              provider.campaignDetails.updates[i].title ?? '-',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: cc.greyFour,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                            sizedBoxCustom(7),
                            Text(
                              provider.campaignDetails.updates[i].description ??
                                  '-',
                              style: TextStyle(color: cc.greyParagraph),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
            ],
          )),
    );
  }
}
