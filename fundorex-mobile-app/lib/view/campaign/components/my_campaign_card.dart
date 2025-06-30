// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/rtl_service.dart';
import 'package:fundorex/view/campaign/components/campaign_helper.dart';
import 'package:fundorex/view/campaign/my_campaign/edit_campaign_page.dart';
import 'package:fundorex/view/campaign/my_campaign/my_campaign_helper.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:provider/provider.dart';

import '../../utils/constant_colors.dart';

class MyCampaignCard extends StatelessWidget {
  const MyCampaignCard({
    super.key,
    required this.imageLink,
    required this.title,
    required this.width,
    required this.marginRight,
    required this.pressed,
    required this.campaignId,
    required this.raisedAmount,
    required this.goalAmount,
    required this.desc,
    required this.categoryId,
    required this.endDate,
    required this.faq,
  });

  final campaignId;
  final imageLink;
  final title;
  final desc;
  final raisedAmount;
  final goalAmount;
  final categoryId;
  final endDate;
  final faq;
  final double width;
  final double marginRight;
  final VoidCallback pressed;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return InkWell(
      onTap: pressed,
      child: Consumer<RtlService>(
        builder: (context, rtlP, child) => Consumer<AppStringService>(
          builder: (context, ln, child) => Container(
            alignment: Alignment.center,
            width: width,
            margin: EdgeInsets.only(
              right: rtlP.direction == 'ltr' ? marginRight : 0,
              left: rtlP.direction == 'ltr' ? 0 : marginRight,
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: cc.borderColor),
                borderRadius: BorderRadius.circular(7)),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: CachedNetworkImage(
                    height: 75,
                    width: double.infinity,
                    imageUrl: imageLink ?? placeHolderUrl,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 13,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sizedBoxCustom(10),
                      //Title
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: cc.greyParagraph,
                            fontSize: 15,
                            height: 1.3,
                            fontWeight: FontWeight.w600),
                      ),

                      sizedBoxCustom(10),
                      //progress bar
                      CampaignHelper().progressBar(raisedAmount, goalAmount),

                      sizedBoxCustom(15),
                      //Raised and Goal
                      Row(
                        children: [
                          //raised
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ln.getString("Raised"),
                                  style: TextStyle(
                                    color: cc.greyParagraph,
                                    fontSize: 11,
                                  ),
                                ),
                                sizedBoxCustom(5),
                                AutoSizeText(
                                  rtlP.currencyDirection == 'left'
                                      ? "${rtlP.currency}${raisedAmount ?? 0}"
                                      : "${raisedAmount ?? 0}${rtlP.currency}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: cc.greyParagraph,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),

                          //divider
                          Container(
                            height: 30,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            width: 2,
                            color: cc.dividerColor,
                          ),

                          //Goal
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ln.getString("Goal"),
                                  style: TextStyle(
                                    color: cc.greyParagraph,
                                    fontSize: 11,
                                  ),
                                ),
                                sizedBoxCustom(5),
                                AutoSizeText(
                                  rtlP.currencyDirection == 'left'
                                      ? "${rtlP.currency}${goalAmount ?? 0}"
                                      : "${goalAmount ?? 0}${rtlP.currency}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: cc.greyParagraph,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                      sizedBoxCustom(15),
                      //Edit button
                      //=============>
                      CommonHelper().buttonPrimary(
                        'Edit',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  EditCampaignPage(
                                      initialTitle: title,
                                      initialDesc: desc,
                                      initialAmount: goalAmount,
                                      initialCategory: categoryId,
                                      initialDate: endDate,
                                      initialImage: imageLink,
                                      campaignId: campaignId,
                                      initialFQA: faq),
                            ),
                          );
                        },
                        paddingVertical: 12,
                        fontsize: 12,
                        borderRadius: 4,
                      ),

                      sizedBoxCustom(10),

                      //Delete button
                      //=============>
                      CommonHelper().buttonPrimary('Delete', () {
                        MyCampaignHelper()
                            .deleteCampaignPopup(context, campaignId);
                      },
                          paddingVertical: 12,
                          fontsize: 12,
                          borderRadius: 4,
                          bgColor: Colors.red),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
