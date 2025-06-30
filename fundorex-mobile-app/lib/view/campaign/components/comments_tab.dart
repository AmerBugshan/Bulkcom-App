import 'package:flutter/material.dart';
import 'package:fundorex/service/campaign_details_service.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

class CommentsTab extends StatelessWidget {
  const CommentsTab({
    super.key,
  });

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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //profile image, rating, feedback
          for (int i = 0;
              i < provider.campaignDetails.comments.data.length;
              i++)
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 45,
                        width: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: cc.primaryColor,
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          provider
                              .campaignDetails.comments.data[i].commentedBy[0],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider
                                  .campaignDetails.comments.data[i].commentedBy,
                              style: TextStyle(
                                  color: cc.greyFour,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),

                            // if one star rating then show one star else loop and show
                            // provider.serviceAllDetails.serviceReviews[i].rating == 0
                            //     ?
                            //     Icon(
                            //         Icons.star,
                            //         color: cc.primaryColor,
                            //         size: 16,
                            //       )
                            //     :

                            //feedback
                            Text(
                              provider.campaignDetails.comments.data[i]
                                  .commentContent,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: cc.greyParagraph,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),

                            //date
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // Text(
                            //   'Mar 21, 2022',
                            //   style: TextStyle(
                            //     color: Colors.grey.withOpacity(.8),
                            //     fontSize: 14,
                            //     height: 1.4,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  //Border bottom
                  const SizedBox(
                    height: 20,
                  ),
                  // i != reviewList.length - 1 ?
                  CommonHelper().dividerCommon()
                  // : Container(),
                ],
              ),
            ),
        ]),
      ),
    );
  }
}
